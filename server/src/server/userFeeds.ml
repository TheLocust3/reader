open Request
open Response
open Util

let add_user_feed user_id source connection =
  (match%lwt Database.UserFeeds.create { user_id = user_id; feed_id = source } connection with
    | Ok _ ->
      Dream.log "[add_user_feed] source: %s - add success" source;
      Lwt.return_ok ()
    | Error e ->
      let message = Model.Error.Database.to_string e in
        Dream.log "[add_user_feed] source: %s - add failed with %s" source message;
        Lwt.return (Error (Model.Error.Database.to_frontend e)))

let get_all_user_feeds user_id connection =
  match%lwt Database.UserFeeds.feeds_by_user_id user_id connection with
    | Ok feeds ->
      Lwt.return feeds
    | Error e ->
      Dream.log "[get_all_user_feeds] - lookup failed with %s" (Model.Error.Database.to_string e);
      Lwt.return []

let remove_user_feed user_id source connection =
  match%lwt Database.UserFeeds.delete user_id source connection with
    | Ok _ ->
      Lwt.return_ok ()
    | Error e ->
      let message = Model.Error.Database.to_string e in
        Dream.log "[remove_user_feed] source: %s - add failed with %s" source message;
        Lwt.return (Error (Model.Error.Database.to_frontend e))

let get_items user_id connection =
  match%lwt Database.UserItems.all_items_by_user_id user_id connection with
    | Ok items ->
      Lwt.return items
    | Error e ->
      Dream.log "[get_items] user_id: %s - lookup failed with %s" user_id (Model.Error.Database.to_string e);
      Lwt.return []

let routes = [
  Dream.scope "/user_feeds" [Util.Middleware.cors; Util.Middleware.require_auth] [
    Dream.post "" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> user_feed_add_request_of_yojson in
        match req with
          | Ok { uri } ->
            Dream.log "[/user_feeds POST] source: %s" uri;
            (match%lwt Dream.sql request (add_user_feed user_id uri) with
              | Ok _ ->
                Dream.log "[/user_feeds POST] source: %s - add success" uri;
                json { message = "ok" } status_response_to_yojson
              | Error e ->
                Dream.log "[/user_feeds POST] source: %s - add failed with %s" uri (Model.Error.Frontend.to_string e);
                throw_error e)
          | _ ->
            throw_error Model.Error.Frontend.BadRequest
    );

    Dream.get "/" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in

      let _ = Dream.log "[/user_feeds/ GET]" in
      let%lwt feeds = Dream.sql request (get_all_user_feeds user_id) in
        json { feeds = List.map Model.Feed.Frontend.to_frontend feeds } all_feeds_response_to_yojson
    );

    Dream.get "/items" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in

      let _ = Dream.log "[/user_feeds/ GET]" in
      let%lwt items = Dream.sql request (get_items user_id) in
        json { items = List.map Model.UserItem.Frontend.to_frontend items } items_response_to_yojson
    );

    Dream.delete "/:source" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in
      let source = Dream.param request "source" in

      let _ = Dream.log "[/user_feeds/:source DELETE] source: %s" source in
      match%lwt Dream.sql request (remove_user_feed user_id source) with
        | Ok _ ->
          Dream.log "[/user_feeds/:source DELETE] source: %s - delete success" source;
          json { message = "ok" } status_response_to_yojson
        | Error e ->
          Dream.log "[/user_feeds/:source DELETE] source: %s - delete failed with %s" source (Model.Error.Frontend.to_string e);
          throw_error e
    );
  ]
]
