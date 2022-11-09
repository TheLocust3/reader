open Model
open Model.FeedList.Internal

let make ~id ~user_id ~name =
  { id = id; user_id = user_id; name = name }

let migrate_query = [%rapper
  execute {sql|
    CREATE TABLE feed_lists (
      id TEXT NOT NULL UNIQUE PRIMARY KEY,
      user_id TEXT NOT NULL,
      name TEXT NOT NULL,
      FOREIGN KEY(user_id) REFERENCES users(id)
    )
  |sql}
  syntax_off
]

let rollback_query = [%rapper
  execute {sql|
    DROP TABLE feed_lists
  |sql}
  syntax_off
]

let create_query = [%rapper
  execute {sql|
    INSERT INTO feed_lists (id, user_id, name)
    VALUES (%string{id}, %string{user_id}, %string{name})
  |sql}
  syntax_off
]

let delete_query = [%rapper
  execute {sql|
    DELETE FROM feed_lists
    WHERE user_id = %string{user_id} AND id = %string{id}
  |sql}
  syntax_off
]

let by_user_id_query = [%rapper
  get_many {sql|
    SELECT @string{feed_lists.id}, @string{feed_lists.user_id}, @string{feed_lists.name}
    FROM feed_lists
    WHERE user_id = %string{user_id}
  |sql}
  function_out
  syntax_off
](make)

let by_id_query = [%rapper
  get_opt {sql|
    SELECT @string{feed_lists.id}, @string{feed_lists.user_id}, @string{feed_lists.name}
    FROM feed_lists
    WHERE user_id = %string{user_id} AND id = %string{id}
  |sql}
  function_out
  syntax_off
](make)

let migrate connection =
  let query = migrate_query() in
    query connection |> Error.Database.or_print

let rollback connection =
  let query = rollback_query() in
    query connection |> Error.Database.or_print

let by_user_id user_id connection =
  let query = by_user_id_query ~user_id: user_id in
    query connection |> Error.Database.or_error

let by_id user_id id connection =
  let query = by_id_query ~user_id: user_id ~id: id in
    query connection |> Error.Database.or_error_opt

let create { id; user_id; name } connection =
  let query = create_query ~id: id ~user_id: user_id ~name: name in
    query connection |> Error.Database.or_error

let delete user_id id connection =
  let query = delete_query ~user_id: user_id ~id: id in
    query connection |> Error.Database.or_error
