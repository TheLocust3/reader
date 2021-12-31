let migrate () =
  let _ = Lwt_main.run (Database.Feeds.migrate()) in
  let _ = Lwt_main.run (Database.Items.migrate()) in
    Printf.printf("Migration complete\n")

let rollback () =
  let _ = Lwt_main.run (Database.Items.rollback()) in
  let _ = Lwt_main.run (Database.Feeds.rollback()) in
    Printf.printf("Rollback complete\n")


let () =
  let mode = Sys.argv.(1) in
    (match mode with
      | "migrate" -> migrate()
      | "rollback" -> rollback()
      | _ -> Printf.printf("Invalid mode argument\n"))
