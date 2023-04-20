open Lwt
open Common

open Response

let json ?(status = `OK) response encoder =
  response |> encoder |> Yojson.Safe.to_string |> Dream.json ~status: status

let throw_error e = match e with
  | Api.Error.Frontend.InternalServerError e ->
    json ~status: `Internal_Server_Error { message = e } status_response_to_yojson
  | Api.Error.Frontend.NotFound ->
    json ~status: `Not_Found { message = "Not found" } status_response_to_yojson
  | Api.Error.Frontend.BadRequest ->
    json ~status: `Bad_Request { message = "Bad request" } status_response_to_yojson

let jwk =
  Jose.Jwk.make_oct "secret_key"

module Central = struct
  open Cohttp_lwt_unix

  let host = (Sys.getenv_opt "CENTRAL_BASE" |> Option.value ~default: "https://central.jakekinsella.com/api")

  module Request = struct
    type validate_request = {
      token : string;
    } [@@deriving yojson]
  end

  module Response = struct
    type user_response = {
      user : Model.User.Frontend.t;
    } [@@deriving yojson]
  end

  let post uri body =
    Client.post (Uri.of_string uri) ~body: (`String body) >>= fun (_, body) ->
      body |> Cohttp_lwt.Body.to_string

  module Users = struct
    open Request
    open Response

    let validate (token) =
      let uri = (host ^ "/users/validate") in
      let body = { token = token } |> validate_request_to_yojson |> Yojson.Safe.to_string in
      let%lwt response = post uri body in
      response |> Yojson.Safe.from_string |> user_response_of_yojson |> Result.map (fun res -> res.user) |> Lwt_result.lift
  end
end

module Middleware = struct
  let user_id =
    Dream.new_field ~name: "user_id" ~show_value: (fun x -> x) ()

  let bearer_token = Str.regexp "Bearer \\(.*\\)"

  let access_denied () =
    json ~status: `Forbidden { message = "Access denied" } status_response_to_yojson

  let try_header request =
    match Dream.header request "authentication" with
      | Some auth ->
        (try
          let _ = Str.string_match bearer_token auth 0 in
          let token = Str.matched_group 1 auth in
          Some token
        with _ -> None)
      | None -> None

  let try_cookie request =
    match Dream.cookie request "token" with
      | Some token -> Some token
      | None -> None

  let validate token =
    (match%lwt Central.Users.validate token with
      | Ok user -> Lwt.return_ok (Some user.id)
      | Error _ -> Lwt.return_ok None)

  let require_auth (inner_handler : Dream.handler) (request : Dream.request) : Dream.response Lwt.t =
    let maybe_token = try_header request |> Magic.Option.or_else (fun _ -> try_cookie request) in
    let%lwt id = maybe_token |> Option.map (fun token -> validate token) |> Option.value ~default: (Lwt.return_ok None) in
    match id with
      | Ok (Some id) ->
        Dream.set_field request user_id id;
        inner_handler request
      | _ ->
        access_denied ()
end
