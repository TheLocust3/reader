module type t = Caqti_lwt.CONNECTION

let url = "sqlite3:db.sqlite"

let connect () =
  match%lwt Caqti_lwt.connect (Uri.of_string url) with
    | Ok connection -> Lwt.return connection
    | Error err -> failwith (Caqti_error.show err)
