open Magic

module Frontend = struct
  type t =
    | InternalServerError of string
    | NotFound
    | BadRequest

  let to_string e = match e with
    | InternalServerError e -> e
    | NotFound -> "Not found"
    | BadRequest -> "Bad request"
end

module Database = struct
  type t =
    | Failure of string
    | NotFound

  let to_string e = match e with
    | Failure e -> e
    | NotFound -> "Not found"

  let or_error m = match%lwt m with
    | Ok a -> Ok a |> Lwt.return
    | Error e -> Error (Failure (Caqti_error.show e)) |> Lwt.return

  let or_error_opt m = match%lwt m with
    | Ok Some a -> Ok a |> Lwt.return
    | Ok None -> Error NotFound |> Lwt.return
    | Error e -> Error (Failure (Caqti_error.show e)) |> Lwt.return

  let or_print m = match%lwt m with
    | Ok _ -> Lwt.return ()
    | Error e -> print_string(Caqti_error.show e ^ "\n"); Lwt.return ()

  let to_frontend e = match e with
    | Failure e -> Frontend.InternalServerError e
    | NotFound -> Frontend.NotFound
end
