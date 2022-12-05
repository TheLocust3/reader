let prune _ =
  Lwt.return ()

let rec run connection =
  let _ = Dream.log "ItemPruner.run - start" in
  let%lwt _ = prune connection in
  let _ = Dream.log "ItemPruner.run - complete" in
  let%lwt _ = Lwt_unix.sleep 5. in
    run connection