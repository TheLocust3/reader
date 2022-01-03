open Model.Feed

let make ~id ~source ~title ~description ~link =
  { id = id; source = Uri.of_string source; title = title; description = description; link = Uri.of_string link; items = [] }

let migrate_query = [%rapper
  execute {sql|
    CREATE TABLE feeds (
      id TEXT NOT NULL UNIQUE PRIMARY KEY,
      source TEXT NOT NULL UNIQUE,
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
    INSERT INTO feeds (id, source, title, description, link)
    VALUES (%string{id}, %string{source}, %string{title}, %string{description}, %string{link})
    ON CONFLICT (id)
    DO UPDATE SET title=excluded.title, description=excluded.description, link=excluded.link
  |sql}
  syntax_off
]

let by_source_query = [%rapper
  get_opt {sql|
    SELECT @string{feeds.id}, @string{feeds.source}, @string{feeds.title}, @string{feeds.description}, @string{feeds.link}
    FROM feeds
    WHERE source = %string{source}
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

let by_source source connection =
  let query = by_source_query ~source: (Uri.to_string source) in
    match%lwt (query connection |> Error.or_error_opt) with
      | Ok feed -> Items.by_feed feed.id connection |> Lwt.map(Result.map(fun items -> { feed with items = items }))
      | Error e -> Error e |> Lwt.return

(* TODO: JK by_id *)

let create { id; source; title; link; description; items } connection =
  let query = create_query ~id: id ~source: (Uri.to_string source) ~title: title ~description: description ~link: (Uri.to_string link) in
  let%lwt _ = query connection |> Error.or_error in
  let%lwt _ = Util.Lwt.flatmap(fun item -> Items.create item id connection)(items) in
    Lwt.return_ok ()
