let puller () =
  let connection = Lwt_main.run (Database.Connect.connect()) in
    Lwt_main.run (Job.Puller.run connection)

let () =
  let mode = Sys.argv.(1) in
    (match mode with
      | "puller" -> puller()
      | _ -> Printf.printf("Invalid mode argument\n"))
