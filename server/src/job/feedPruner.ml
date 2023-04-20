open Common

let prune connection =
  match%lwt (Database.UserFeeds.garbage_collect connection) with
    | Ok (Some feed) ->
      let _ = Dream.log "FeedPruner.prune - found %s" (Uri.to_string feed.source) in
      let%lwt _ = Database.Feeds.delete feed.source connection in
      let _ = Dream.log "FeedPruner.prune - deleted %s" (Uri.to_string feed.source) in
        Lwt.return ()
    | Ok None ->
      let _ = Dream.log "FeedPruner.prune - nothing to prune" in
        Lwt.return ()
    | Error e ->
      let _  = Dream.log "FeedPruner.prune - lookup failed with %s" (Api.Error.Database.to_string e) in
        Lwt.return ()

let rec run connection =
  let _ = Dream.log "FeedPruner.run - start" in
  let%lwt _ = prune connection in
  let _ = Dream.log "FeedPruner.run - complete" in
  let%lwt _ = Lwt_unix.sleep 15. in
    run connection