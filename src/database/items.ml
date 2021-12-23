open Model.Feed.Item

let migrate_query = [%rapper
  execute {sql|
    CREATE TABLE items (
      uid TEXT NOT NULL PRIMARY KEY,
      title TEXT,
      link TEXT,
      description TEXT,
      feed INT,
      FOREIGN KEY(feed) REFERENCES feeds(id)
    )
  |sql}
  syntax_off
]

let rollback_query = [%rapper
  execute {sql|
    DROP TABLE items
  |sql}
  syntax_off
]

let create_query = [%rapper
  execute {sql|
    INSERT INTO items (title, link, description, feed) VALUES(%string{title}, %string{link}, %string{description}, %int{feed})
  |sql}
  syntax_off
]

let migrate () =
  let pool = Connect.testPool() in
  let query = migrate_query() in
    Caqti_lwt.Pool.use query pool |> Error.or_print

let rollback () =
  let pool = Connect.testPool() in
  let query = rollback_query() in
    Caqti_lwt.Pool.use query pool |> Error.or_print

let create connection { title; link; description } feed =
  let query = create_query ~title: title ~link: link ~description: description ~feed: feed in
    query connection |> Error.or_error
