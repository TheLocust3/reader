open Model

open Request
open Response
open Util

let routes = [
  Dream.scope "/api/users" [Util.Middleware.cors] [
    Dream.post "/login" (fun request ->
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> login_request_of_yojson in
        match req with
          | Ok { email; password = password } ->
            Dream.log "[/users/login] email: %s" email;
            (match%lwt Dream.sql request (Database.Users.by_email email) with
              | Ok user ->
                Dream.log "[/users/login] email: %s - lookup success" email;
                if Model.User.Internal.verify password user
                  then
                    let token = Model.User.Internal.sign jwk user in
                      json { token = token } login_response_to_yojson
                  else throw_error Model.Error.Frontend.NotFound
              | Error e ->
                let message = Error.Database.to_string e in
                  Dream.log "[/users/login] email: %s - lookup failed with %s" email message;
                throw_error Model.Error.Frontend.NotFound)
          | _ ->
            throw_error Model.Error.Frontend.BadRequest
    );
  ]
]