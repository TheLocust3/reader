open Model
open Model.Feed.Internal

let make ~source ~title ~description ~link =
  { source = Uri.of_string source; title = title; description = description; link = Uri.of_string link; }

let migrate_query = [%rapper
  execute {sql|
    CREATE TABLE feeds (
      source TEXT NOT NULL UNIQUE PRIMARY KEY,
      title TEXT,
      description TEXT,
      link TEXT,
      last_pulled_at DATETIME DEFAULT (datetime(0)) NOT NULL
    )
  |sql}
  syntax_off
]

let rollback_query = [%rapper
  execute {sql|
    DROP TABLE feeds
  |sql}
  syntax_off
]

let create_query = [%rapper
  execute {sql|
    INSERT INTO feeds (source, title, description, link)
    VALUES (%string{source}, %string{title}, %string{description}, %string{link})
    ON CONFLICT (source)
    DO UPDATE SET title=excluded.title, description=excluded.description, link=excluded.link
  |sql}
  syntax_off
]

let by_source_query = [%rapper
  get_opt {sql|
    SELECT @string{feeds.source}, @string{feeds.title}, @string{feeds.description}, @string{feeds.link}
    FROM feeds
    WHERE source = %string{source}
  |sql}
  function_out
  syntax_off
](make)

let pull_query = [%rapper
  get_opt {sql|
    UPDATE feeds
    SET last_pulled_at = datetime('now')
    WHERE source IN (
      SELECT source
      FROM feeds
      WHERE last_pulled_at < datetime('now', '-10 minutes')
      ORDER BY last_pulled_at DESC
      LIMIT 1
    )
    RETURNING @string{feeds.source}, @string{feeds.title}, @string{feeds.description}, @string{feeds.link}
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

let by_source source connection =
  let query = by_source_query ~source: (Uri.to_string source) in
    query connection |> Error.Database.or_error_opt

let create { source; title; link; description } connection =
  let query = create_query ~source: (Uri.to_string source) ~title: title ~description: description ~link: (Uri.to_string link) in
  let%lwt _ = query connection |> Error.Database.or_error in
    Lwt.return_ok ()

let pull connection =
  let query = pull_query() in
    query connection |> Error.Database.or_error
