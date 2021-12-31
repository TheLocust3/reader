open Model.Feed

let make ~source ~title ~description ~link =
  { source = Uri.of_string source; title = title; description = description; link = Uri.of_string link; items = [] }

let migrate_query = [%rapper
  execute {sql|
    CREATE TABLE feeds (
      source TEXT NOT NULL UNIQUE PRIMARY KEY,
      title TEXT,
      description TEXT,
      link TEXT
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

let migrate () =
  let pool = Connect.testPool() in
  let query = migrate_query() in
    Caqti_lwt.Pool.use query pool |> Error.or_print

let rollback () =
  let pool = Connect.testPool() in
  let query = rollback_query() in
    Caqti_lwt.Pool.use query pool |> Error.or_print

let by_source source connection =
  let feed_ref = (Uri.to_string source) in
  let query = by_source_query ~source: feed_ref in
    match%lwt (query connection |> Error.or_error_opt) with
    | Ok feed -> Items.by_feed feed_ref connection |> Lwt.map(Result.map(fun items -> { feed with items = items }))
    | Error e -> Error e |> Lwt.return

let create { source; title; link; description; items } connection =
  let feed_ref = (Uri.to_string source) in
  let query = create_query ~source: feed_ref ~title: title ~description: description ~link: (Uri.to_string link) in
  let%lwt _ = query connection |> Error.or_error in
  let%lwt _ = Util.Lwt.flatmap(fun item -> Items.create item feed_ref connection)(items) in
    Lwt.return_ok ()
