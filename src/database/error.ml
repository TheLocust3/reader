type t =
  | DatabaseError of string
  | NotFound

let to_string e = match e with
  | DatabaseError e -> e
  | NotFound -> "Not found"

let or_error m =
  match%lwt m with
  | Ok a -> Ok a |> Lwt.return
  | Error e -> Error (DatabaseError (Caqti_error.show e)) |> Lwt.return

let or_error_opt m =
  match%lwt m with
  | Ok Some a -> Ok a |> Lwt.return
  | Ok None -> Error NotFound |> Lwt.return
  | Error e -> Error (DatabaseError (Caqti_error.show e)) |> Lwt.return

let or_print m =
  match%lwt m with
  | Ok _ -> Lwt.return ()
  | Error e -> print_string(Caqti_error.show e ^ "\n"); Lwt.return ()