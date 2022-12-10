open Response
open Util

let set_read user_id item_id connection =
  (match%lwt Database.UserItems.set_read user_id item_id connection with
    | Ok _ ->
      Dream.log "[set_read] item_id: %s - add success" item_id;
      Lwt.return_ok ()
    | Error e ->
      let message = Model.Error.Database.to_string e in
        Dream.log "[set_read] item_id: %s - add failed with %s" item_id message;
        Lwt.return (Error (Model.Error.Database.to_frontend e)))

let routes = [
  Dream.scope "/api/user_items" [Util.Middleware.cors; Util.Middleware.require_auth] [
    Dream.post "/:item_id/read" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in
      let item_id = Dream.param request "item_id" in

      Dream.log "[/user_items/:item_id/read POST] item_id: %s" item_id;
      match%lwt Dream.sql request (set_read user_id item_id) with
        | Ok _ ->
          Dream.log "[/user_items/:item_id/read POST] item_id: %s - read success" item_id;
          json { message = "ok" } status_response_to_yojson
        | Error e ->
          Dream.log "[/user_items/:item_id/read POST] item_id: %s - read failed with %s" item_id (Model.Error.Frontend.to_string e);
          throw_error e
    );
  ]
]
