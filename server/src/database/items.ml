open Model.Feed.Item

let migrate_query = [%rapper
  execute {sql|
    CREATE TABLE items (
      id TEXT NOT NULL UNIQUE PRIMARY KEY,
      feed TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
      title TEXT,
      link TEXT NOT NULL,
      description TEXT,
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
    INSERT INTO items (id, title, link, description, feed)
    VALUES (%string{id}, %string{title}, %string{link}, %string{description}, %string{feed})
    ON CONFLICT (id)
    DO UPDATE SET title=excluded.title, link=excluded.link, description=excluded.description
  |sql}
  syntax_off
]

let by_feed_query = [%rapper
  get_many {sql|
    SELECT @string{items.id}, @string{items.title}, @string{items.link}, @string{items.description}
    FROM items
    WHERE feed = %string{feed}
    ORDER BY items.created_at DESC
  |sql}
  record_out
  syntax_off
]

let migrate connection =
  let query = migrate_query() in
    query connection |> Error.or_print

let rollback connection =
  let query = rollback_query() in
    query connection |> Error.or_print

let by_feed feed connection =
  let query = by_feed_query ~feed: feed in
    query connection |> Error.or_error

let create { id; title; link; description } feed connection =
  let query = create_query ~id: id ~title: title ~link: link ~description: description ~feed: feed in
    query connection |> Error.or_error
