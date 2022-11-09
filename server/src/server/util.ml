open Model
open Response

let json ?(status = `OK) response encoder =
  response |> encoder |> Yojson.Safe.to_string |> Dream.json ~status: status

let throw_error e = match e with
  | Error.Frontend.InternalServerError e ->
    json ~status: `Internal_Server_Error { message = e } status_response_to_yojson
  | Error.Frontend.NotFound ->
    json ~status: `Not_Found { message = "Not found" } status_response_to_yojson
  | Error.Frontend.BadRequest ->
    json ~status: `Bad_Request { message = "Bad request" } status_response_to_yojson

let jwk =
  Jose.Jwk.make_oct "secret_key"

module Middleware = struct
  let user_id =
    Dream.new_field ~name: "user_id" ~show_value: (fun x -> x) ()

  let bearer_token = Str.regexp "Bearer \\(.*\\)"

  let access_denied () =
    json ~status: `Forbidden { message = "Access denied" } status_response_to_yojson

  let require_auth (inner_handler : Dream.handler) (request : Dream.request) : Dream.response Lwt.t =
    match (Dream.header request "authentication") with
      | Some auth ->
        (try
          let _ = Str.string_match bearer_token auth 0 in
            match (Str.matched_group 1 auth |> Model.User.Internal.validate jwk) with
              | Ok id ->
                Dream.set_field request user_id id;
                inner_handler request
              | Error _ -> access_denied ()
        with _ -> access_denied ())
      | None ->
        access_denied ()
end
