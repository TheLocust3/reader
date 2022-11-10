let routes = [
  Dream.scope "" [Util.Middleware.cors] [
    Dream.options "**" (fun _ ->
      Dream.respond ~headers: [("Allow", "OPTIONS, GET, HEAD, POST")] ""
    )
  ]
]