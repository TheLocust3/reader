let migrate () =
  let connection = Lwt_main.run (Database.Connect.connect()) in
  
  let test_user = Model.User.Internal.build ~email: "jake.kinsella@gmail.com" ~password: "foobar" in
  let read_later = Model.Board.Internal.build ~user_id: test_user.id ~name: "Read Later" in

  let _ = Lwt_main.run (Database.Feeds.migrate connection) in
  let _ = Lwt_main.run (Database.Items.migrate connection) in
  let _ = Lwt_main.run (Database.Users.migrate connection) in
  let _ = Lwt_main.run (Database.Boards.migrate connection) in
  let _ = Lwt_main.run (Database.BoardEntries.migrate connection) in

  let _ = Lwt_main.run (Database.Users.create test_user connection) in
  let _ = Lwt_main.run (Database.Boards.create read_later connection) in
    Printf.printf("Migration complete\n")

let rollback () =
  let connection = Lwt_main.run (Database.Connect.connect()) in
  let _ = Lwt_main.run (Database.BoardEntries.rollback connection) in
  let _ = Lwt_main.run (Database.Boards.rollback connection) in
  let _ = Lwt_main.run (Database.Users.rollback connection) in
  let _ = Lwt_main.run (Database.Items.rollback connection) in
  let _ = Lwt_main.run (Database.Feeds.rollback connection) in
    Printf.printf("Rollback complete\n")

let () =
  let mode = Sys.argv.(1) in
    (match mode with
      | "migrate" -> migrate()
      | "rollback" -> rollback()
      | _ -> Printf.printf("Invalid mode argument\n"))
