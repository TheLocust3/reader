module type t = Caqti_lwt.CONNECTION

let url =
  let user = Sys.getenv "PGUSER" in
  let password = Sys.getenv "PGPASSWORD" in
  let host = Sys.getenv "PGHOST" in
  let port = Sys.getenv "PGPORT" in
  let database = Sys.getenv "PGDATABASE" in
    "postgresql://" ^ user ^ ":" ^ password ^ "@" ^ host ^ ":" ^ port ^ "/" ^ database

let connect () =
  match%lwt Caqti_lwt.connect (Uri.of_string url) with
    | Ok connection -> Lwt.return connection
    | Error err -> failwith (Caqti_error.show err)
