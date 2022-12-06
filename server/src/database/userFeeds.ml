open Model
open Model.UserFeed.Internal

let make ~user_id ~feed_id =
  { user_id = user_id; feed_id = feed_id }

let migrate_query = [%rapper
  execute {sql|
    CREATE TABLE user_feeds (
      user_id TEXT NOT NULL,
      feed_id TEXT NOT NULL,
      FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY(feed_id) REFERENCES feeds(source) ON DELETE CASCADE,
      PRIMARY KEY(user_id, feed_id)
    )
  |sql}
  syntax_off
]

let rollback_query = [%rapper
  execute {sql|
    DROP TABLE user_feeds
  |sql}
  syntax_off
]

let create_query = [%rapper
  execute {sql|
    INSERT INTO user_feeds (user_id, feed_id)
    VALUES (%string{user_id}, %string{feed_id})
  |sql}
  syntax_off
]

let delete_query = [%rapper
  execute {sql|
    DELETE FROM user_feeds
    WHERE user_id = %string{user_id} AND feed_id = %string{feed_id}
  |sql}
  syntax_off
]

let feeds_by_user_id_query = [%rapper
  get_many {sql|
    SELECT @string{feeds.source}, @string{feeds.title}, @string{feeds.description}, @string{feeds.link}
    FROM user_feeds, feeds
    WHERE user_feeds.user_id = %string{user_id} AND user_feeds.feed_id = feeds.source
  |sql}
  function_out
  syntax_off
](Feeds.make)

let items_by_user_id_query = [%rapper
  get_many {sql|
    SELECT @string{items.id}, @string{items.from_feed}, @string{items.link}, @string{items.title}, @string{items.description}
    FROM user_feeds, items
    WHERE user_feeds.user_id = %string{user_id} AND user_feeds.feed_id = items.from_feed
    ORDER BY items.created_at DESC
  |sql}
  function_out
  syntax_off
](Items.make)

let garbage_collect_query = [%rapper
  get_opt {sql|
    SELECT @string{feeds.source}, @string{feeds.title}, @string{feeds.description}, @string{feeds.link}
    FROM feeds
    LEFT JOIN user_feeds ON user_feeds.feed_id = feeds.source
    WHERE user_feeds.feed_id IS NULL
    LIMIT 1
  |sql}
  function_out
  syntax_off
](Feeds.make)

let migrate connection =
  let query = migrate_query() in
    query connection |> Error.Database.or_print

let rollback connection =
  let query = rollback_query() in
    query connection |> Error.Database.or_print

let create { user_id; feed_id } connection =
  let query = create_query ~user_id: user_id ~feed_id: feed_id in
    query connection |> Error.Database.or_error

let delete user_id feed_id connection =
  let query = delete_query ~user_id: user_id ~feed_id: feed_id in
    query connection |> Error.Database.or_error

let feeds_by_user_id user_id connection =
  let query = feeds_by_user_id_query ~user_id: user_id in
    query connection |> Error.Database.or_error

let items_by_user_id user_id connection =
  let query = items_by_user_id_query ~user_id: user_id in
    query connection |> Error.Database.or_error

let garbage_collect connection =
  let query = garbage_collect_query() in
    query connection |> Error.Database.or_error
