let migrate () =
  let connection = Lwt_main.run (Database.Connect.connect()) in
  
  let test_user = Model.User.Internal.build ~email: "jake.kinsella@gmail.com" ~password: (Option.value (Sys.getenv_opt "USER_PASSWORD") ~default: "foobar") in

  let _ = Lwt_main.run (Database.Feeds.migrate connection) in
  let _ = Lwt_main.run (Database.Items.migrate connection) in
  let _ = Lwt_main.run (Database.Users.migrate connection) in
  let _ = Lwt_main.run (Database.Boards.migrate connection) in
  let _ = Lwt_main.run (Database.BoardEntries.migrate connection) in
  let _ = Lwt_main.run (Database.UserFeeds.migrate connection) in
  let _ = Lwt_main.run (Database.UserItems.migrate connection) in

  let _ = Lwt_main.run (Database.Users.create test_user connection) in
    Printf.printf("Migration complete\n")

let rollback () =
  let connection = Lwt_main.run (Database.Connect.connect()) in
  let _ = Lwt_main.run (Database.UserItems.rollback connection) in
  let _ = Lwt_main.run (Database.UserFeeds.rollback connection) in
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
