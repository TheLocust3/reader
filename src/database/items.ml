open Model.Feed.Item

let migrate_query = [%rapper
  execute {sql|
    CREATE TABLE items (
      feed TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
      title TEXT,
      link TEXT NOT NULL,
      description TEXT,
      FOREIGN KEY(feed) REFERENCES feeds(source),
      PRIMARY KEY (feed, link)
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
    INSERT INTO items (title, link, description, feed)
    VALUES (%string{title}, %string{link}, %string{description}, %string{feed})
    ON CONFLICT (feed, link)
    DO UPDATE SET title=excluded.title, link=excluded.link, description=excluded.description
  |sql}
  syntax_off
]

let by_feed_query = [%rapper
  get_many {sql|
    SELECT @string{items.title}, @string{items.link}, @string{items.description}
    FROM items
    WHERE feed = %string{feed}
    ORDER BY items.created_at DESC
  |sql}
  record_out
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

let by_feed connection feed =
  let query = by_feed_query ~feed: feed in
    query connection |> Error.or_error

let create connection { title; link; description } feed =
  let query = create_query ~title: title ~link: link ~description: description ~feed: feed in
    query connection |> Error.or_error
