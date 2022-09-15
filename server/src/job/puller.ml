let pull connection =
  match%lwt (Database.Feeds.pull connection) with
    | Ok feed ->
      let _ = Dream.log "Puller.pull - found %s" (Uri.to_string feed.source) in
        Lwt.return ()
    | Error e ->
      let _  = Dream.log "Puller.pull - lookup failed with %s" (Model.Error.Database.to_string e) in
        Lwt.return ()

let rec run connection =
  let _ = Dream.log "Puller.run - start" in
  let%lwt _ = pull connection in
  let _ = Dream.log "Puller.run - complete" in
  let%lwt _ = Lwt_unix.sleep 5. in
    run connection
