let run () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool Database.Connect.url
  @@ Dream.router (Users.routes @ Feeds.routes)