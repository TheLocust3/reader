type t =
  | Database_error of string

let or_error m =
  match%lwt m with
  | Ok a -> Ok a |> Lwt.return
  | Error e -> Error (Database_error (Caqti_error.show e)) |> Lwt.return

let or_print m =
  match%lwt m with
  | Ok _ -> Lwt.return ()
  | Error e -> print_string(Caqti_error.show e ^ "\n"); Lwt.return ()