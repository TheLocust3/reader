let puller () =
  Lwt_main.run (Job.Puller.run())

let () =
  let mode = Sys.argv.(1) in
    (match mode with
      | "puller" -> puller()
      | _ -> Printf.printf("Invalid mode argument\n"))
