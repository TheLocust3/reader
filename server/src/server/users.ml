open Request
open Response
open Util

let routes = [
  Dream.post "/users/login" (fun request ->
    let%lwt body = Dream.body request in

    let req = body |> Yojson.Safe.from_string |> login_request_of_yojson in
      match req with
        | Ok { email; password = password } ->
          Dream.log "[/users/login] email: %s" email;
          (match%lwt Dream.sql request (Database.Users.by_email email) with
            | Ok user ->
              Dream.log "[/users/login] email: %s - lookup success" email;
              if Model.User.verify password user
                then
                  let token = Model.User.sign jwk user in
                    json { token = token } login_response_to_yojson
                else json ~status: `Not_Found { message = "Not found" } status_response_to_yojson
            | Error e ->
              let message = Database.Error.to_string e in
                Dream.log "[/users/login] email: %s - lookup failed with %s" email message;
                json ~status: `Not_Found { message = "Not found" } status_response_to_yojson)
        | _ ->
          bad_request
  );
]