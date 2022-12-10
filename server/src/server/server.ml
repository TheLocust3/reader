let run () =
  let _ = Random.self_init () in
    Dream.run
    @@ Dream.logger
    @@ Dream.sql_pool ~size: 10 Database.Connect.url
    @@ Dream.router (Users.routes @ Feeds.routes @ Boards.routes @ UserFeeds.routes @ UserItems.routes @ Cors.routes)