open Model.Item.Internal

let make ~id ~from_feed ~link ~title ~description =
  { id = id; from_feed = Uri.of_string from_feed; link = Uri.of_string link; title = title; description = description }

let migrate_query = [%rapper
  execute {sql|
    CREATE TABLE items (
      id TEXT NOT NULL UNIQUE PRIMARY KEY,
      from_feed TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
      link TEXT NOT NULL,
      title TEXT,
      description TEXT,
      FOREIGN KEY(from_feed) REFERENCES feeds(id)
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
    INSERT INTO items (id, title, link, description, from_feed)
    VALUES (%string{id}, %string{from_feed}, %string{link}, %string{title}, %string{description})
    ON CONFLICT (id)
    DO UPDATE SET title=excluded.title, link=excluded.link, description=excluded.description
  |sql}
  syntax_off
]

let by_feed_query = [%rapper
  get_many {sql|
    SELECT @string{items.id}, @string{items.from_feed}, @string{items.link}, @string{items.title}, @string{items.description}
    FROM items
    WHERE from_feed = %string{from_feed}
    ORDER BY items.created_at DESC
  |sql}
  function_out
  syntax_off
](make)

let migrate connection =
  let query = migrate_query() in
    query connection |> Error.or_print

let rollback connection =
  let query = rollback_query() in
    query connection |> Error.or_print

let by_feed feed connection =
  let query = by_feed_query ~from_feed: feed in
    query connection |> Error.or_error

let create { id; from_feed; link; title; description } connection =
  let query = create_query ~id: id ~from_feed: (Uri.to_string from_feed) ~link: (Uri.to_string link) ~title: title ~description: description in
    query connection |> Error.or_error
