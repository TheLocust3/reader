module type t = Caqti_lwt.CONNECTION

let url = "sqlite3:db.sqlite"

let testPool () =
  match Caqti_lwt.connect_pool ~max_size:1 (Uri.of_string url) with
    | Ok pool -> pool
    | Error err -> failwith (Caqti_error.show err)
