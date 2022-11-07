let pull connection =
  match%lwt (Database.Feeds.pull connection) with
    | Ok (Some feed) ->
      let _ = Dream.log "Puller.pull - found %s" (Uri.to_string feed.source) in
      let%lwt document = Source.Rss.from_uri feed.source in
      let items = document |> Option.map (fun (doc : Source.Rss.t) -> doc.items) |> Option.to_list |> List.flatten in
      let _ = Dream.log "Puller.pull - storing %d items" (List.length items) in
      let%lwt _ = Magic.Lwt.flatmap(fun item -> Database.Items.create item connection)(items) in
        Lwt.return ()
    | Ok None ->
      let _ = Dream.log "Puller.pull - nothing to pull" in
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
