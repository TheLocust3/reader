let routes = [
  Dream.scope "" [Util.Middleware.cors] [
    Dream.options "**" (fun _ ->
      Dream.respond ~headers: [("Access-Control-Allow-Methods", "OPTIONS, GET, HEAD, POST, DELETE")] ""
    )
  ]
]