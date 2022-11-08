open Model
open Model.FeedListEntry.Internal

let make ~list_id ~feed_id =
  { list_id = list_id; feed_id = feed_id }

let migrate_query = [%rapper
  execute {sql|
    CREATE TABLE feed_list_entries (
      list_id TEXT NOT NULL,
      feed_id TEXT NOT NULL,
      FOREIGN KEY(list_id) REFERENCES lists(id),
      FOREIGN KEY(feed_id) REFERENCES feeds(id),
      PRIMARY KEY(list_id, feed_id)
    )
  |sql}
  syntax_off
]

let rollback_query = [%rapper
  execute {sql|
    DROP TABLE feed_list_entries
  |sql}
  syntax_off
]

let create_query = [%rapper
  execute {sql|
    INSERT INTO feed_list_entries (list_id, feed_id)
    VALUES (%string{list_id}, %string{feed_id})
  |sql}
  syntax_off
]

let delete_query = [%rapper
  execute {sql|
    DELETE FROM feed_list_entries
    WHERE list_id = %string{list_id} AND feed_id = %string{feed_id}
  |sql}
  syntax_off
]

let feeds_by_list_id_query = [%rapper
  get_many {sql|
    SELECT @string{feeds.source}, @string{feeds.title}, @string{feeds.description}, @string{feeds.link}
    FROM feed_lists, feeds
    WHERE feed_lists.list_id = %string{list_id} AND feed_lists.feed_id = feeds.id
  |sql}
  function_out
  syntax_off
](Feeds.make)

let items_by_list_id_query = [%rapper
  get_many {sql|
    SELECT @string{items.id}, @string{items.from_feed}, @string{items.link}, @string{items.title}, @string{items.description}
    FROM feed_lists, items
    WHERE feed_lists.list_id = %string{list_id} AND feed_lists.feed_id = items.from_feed
  |sql}
  function_out
  syntax_off
](Items.make)

let migrate connection =
  let query = migrate_query() in
    query connection |> Error.Database.or_print

let rollback connection =
  let query = rollback_query() in
    query connection |> Error.Database.or_print

let create { list_id; feed_id } connection =
  let query = create_query ~list_id: list_id ~feed_id: feed_id in
    query connection |> Error.Database.or_error

let delete { list_id; feed_id } connection =
  let query = delete_query ~list_id: list_id ~feed_id: feed_id in
    query connection |> Error.Database.or_error

let feeds_by_list_id list_id connection =
  let query = feeds_by_list_id_query ~list_id: list_id in
    query connection |> Error.Database.or_error

let items_by_list_id list_id connection =
  let query = items_by_list_id_query ~list_id: list_id in
    query connection |> Error.Database.or_error
