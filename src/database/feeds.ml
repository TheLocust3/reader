open Model.Feed

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

let migrate () =
  let pool = Connect.testPool() in
  let query = migrate_query() in
    Caqti_lwt.Pool.use query pool |> Error.or_print

let rollback () =
  let pool = Connect.testPool() in
  let query = rollback_query() in
    Caqti_lwt.Pool.use query pool |> Error.or_print

let get_by_source _ =
  Ok [] |> Lwt.return

let create connection { source; title; link; description; items } =
  let feed_ref = (Uri.to_string source) in
  let query = create_query ~source: feed_ref ~title: title ~description: description ~link: (Uri.to_string link) in
  let%lwt _ = query connection |> Error.or_error in
  let%lwt _ = Util.Lwt.flatmap(fun item -> Items.create connection item feed_ref)(items) in
    Lwt.return_ok ()
