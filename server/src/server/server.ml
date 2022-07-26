let run () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool Database.Connect.url
  @@ Dream.router Users.routes
  @@ Util.Middleware.require_auth
  @@ Dream.router Feeds.routes
  @@ Dream.not_found