let puller () =
  let connection = Lwt_main.run (Database.Connect.connect()) in
    Lwt_main.run (Job.Puller.run connection)

let feed_pruner () =
  let connection = Lwt_main.run (Database.Connect.connect()) in
    Lwt_main.run (Job.FeedPruner.run connection)

let item_pruner () =
  let connection = Lwt_main.run (Database.Connect.connect()) in
    Lwt_main.run (Job.ItemPruner.run connection)

let () =
  let mode = Sys.argv.(1) in
    (match mode with
      | "puller" -> puller()
      | "feed-pruner" -> feed_pruner()
      | "item-pruner" -> item_pruner()
      | _ -> Printf.printf("Invalid mode argument\n"))
