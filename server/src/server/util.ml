open Response

let json ?(status = `OK) response encoder =
  response |> encoder |> Yojson.Safe.to_string |> Dream.json ~status: status

let bad_request =
  Dream.empty `Bad_Request

let jwk =
  Jose.Jwk.make_oct "secret_key"

let user_id =
  Dream.new_local ~name: "user_id" ~show_value: (fun x -> x) ()

module Middleware = struct
  let bearer_token = Str.regexp "Bearer \\(.*\\)"

  let access_denied () =
    json ~status: `Forbidden { message = "Access denied" } status_response_to_yojson

  let require_auth inner_handler request =
    match (Dream.header "authentication" request) with
      | Some auth ->
        (try
          let _ = Str.string_match bearer_token auth 0 in
            Str.matched_group 1 auth
            |> Model.User.validate jwk
            |> Result.map(fun id -> Dream.with_local user_id id request)
            |> Result.map(fun req -> inner_handler req)
            |> Result.value ~default: (access_denied ())
        with _ -> access_denied ())
      | None ->
        access_denied ()
end
