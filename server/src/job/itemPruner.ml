let prune connection =
  match%lwt (Database.UserItems.garbage_collect connection) with
    | Ok (Some item) ->
      let _ = Dream.log "ItemPruner.prune - found %s" item.id in
      let%lwt _ = Database.Items.delete item.id connection in
      let _ = Dream.log "ItemPruner.prune - deleted %s" item.id in
        Lwt.return ()
    | Ok None ->
      let _ = Dream.log "ItemPruner.prune - nothing to prune" in
        Lwt.return ()
    | Error e ->
      let _  = Dream.log "ItemPruner.prune - lookup failed with %s" (Model.Error.Database.to_string e) in
        Lwt.return ()

let rec run connection =
  let _ = Dream.log "ItemPruner.run - start" in
  let%lwt _ = prune connection in
  let _ = Dream.log "ItemPruner.run - complete" in
  let%lwt _ = Lwt_unix.sleep 5. in
    run connection