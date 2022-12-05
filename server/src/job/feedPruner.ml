let prune _ =
  Lwt.return ()

let rec run connection =
  let _ = Dream.log "FeedPruner.run - start" in
  let%lwt _ = prune connection in
  let _ = Dream.log "FeedPruner.run - complete" in
  let%lwt _ = Lwt_unix.sleep 15. in
    run connection