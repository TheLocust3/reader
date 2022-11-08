open Magic

open Request
open Response
open Util

let create_list _ _ =
  Lwt.return_ok ()

let routes = [
  Dream.scope "/lists" [Util.Middleware.require_auth] [
    Dream.post "" (fun request ->
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> list_create_request_of_yojson in
        match req with
          | Ok { name } ->
            Dream.log "[/lists POST] name: %s" name;
            (match%lwt Dream.sql request (create_list name) with
              | Ok _ ->
                Dream.log "[/lists POST] name: %s - add success" name;
                json { message = "ok" } status_response_to_yojson
              | Error e ->
                Dream.log "[/lists POST] name: %s - add failed with %s" name (Model.Error.Frontend.to_string e);
                throw_error e)
          | _ ->
            throw_error Model.Error.Frontend.BadRequest
    );
  ]
]
