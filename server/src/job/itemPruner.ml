open Common

let prune connection =
  match%lwt (Database.UserItems.garbage_collect connection) with
    | Ok items ->
      let _ = Dream.log "ItemPruner.prune - found %d" (List.length items) in
      let%lwt _ = Common.Magic.Lwt.flatmap (fun (item : Model.Item.Internal.t) -> Database.Items.delete item.id connection) items in
      let _ = Dream.log "ItemPruner.prune - deleted" in
        Lwt.return ()
    | Error e ->
      let _  = Dream.log "ItemPruner.prune - lookup failed with %s" (Api.Error.Database.to_string e) in
        Lwt.return ()

let rec run connection =
  let _ = Dream.log "ItemPruner.run - start" in
  let%lwt _ = prune connection in
  let _ = Dream.log "ItemPruner.run - complete" in
  let%lwt _ = Lwt_unix.sleep 3. in
    run connection