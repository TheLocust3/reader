let run () =
  let _ = Random.self_init () in
    Dream.run ~interface: "0.0.0.0" ~port: (Sys.getenv_opt "PORT" |> Option.value ~default: "8080" |> int_of_string)
    @@ Dream.logger
    @@ Dream.sql_pool ~size: 10 Database.Connect.url
    @@ Dream.router (Feeds.routes @ Boards.routes @ UserFeeds.routes @ UserItems.routes @ Common.Middleware.Cors.routes)