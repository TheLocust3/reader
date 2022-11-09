open Magic

open Request
open Response
open Util

let create_list user_id name connection =
  let id = Uuidm.v4_gen(Random.get_state())() |> Uuidm.to_string in
  (match%lwt Database.FeedLists.create { id; user_id; name } connection with
    | Ok _ ->
      Dream.log "[create_list] name: %s - add success" name;
      Lwt.return_ok ()
    | Error e ->
      let message = Model.Error.Database.to_string e in
        Dream.log "[create_list] name: %s - add failed with %s" name message;
        Lwt.return (Error (Model.Error.Database.to_frontend e)))

let get_all_lists user_id connection =
  match%lwt Database.FeedLists.by_user_id user_id connection with
    | Ok feed_lists ->
        Lwt.return feed_lists
    | Error e ->
      Dream.log "[get_all_lists] - lookup failed with %s" (Model.Error.Database.to_string e);
      Lwt.return []

let get_list user_id id connection =
  match%lwt Database.FeedLists.by_id user_id id connection with
    | Ok feed_list ->
      let%lwt _feeds = Database.FeedListEntries.feeds_by_list_id id connection in
      let feeds = _feeds |> Result.to_list |> List.flatten in
        Lwt.return (Some (feed_list, feeds))
    | Error e ->
      Dream.log "[get_list] id: %s - lookup failed with %s" id (Model.Error.Database.to_string e);
      Lwt.return None

let delete_list user_id id connection =
  match%lwt Database.FeedLists.delete user_id id connection with
    | Ok _ ->
      Lwt.return_ok ()
    | Error e ->
      let message = Model.Error.Database.to_string e in
        Dream.log "[delete_list] id: %s - add failed with %s" id message;
        Lwt.return (Error (Model.Error.Database.to_frontend e))

let get_list_items user_id id connection =
  match%lwt Database.FeedLists.by_id user_id id connection with
    | Ok feed_list ->
      let%lwt _items = Database.FeedListEntries.items_by_list_id id connection in
      let items = _items |> Result.to_list |> List.flatten in
        Lwt.return (Some (feed_list, items))
    | Error e ->
      Dream.log "[get_list_items] id: %s - lookup failed with %s" id (Model.Error.Database.to_string e);
      Lwt.return None

let routes = [
  Dream.scope "/lists" [Util.Middleware.require_auth] [
    Dream.post "" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> list_create_request_of_yojson in
        match req with
          | Ok { name } ->
            Dream.log "[/lists POST] name: %s" name;
            (match%lwt Dream.sql request (create_list user_id name) with
              | Ok _ ->
                Dream.log "[/lists POST] name: %s - add success" name;
                json { message = "ok" } status_response_to_yojson
              | Error e ->
                Dream.log "[/lists POST] name: %s - add failed with %s" name (Model.Error.Frontend.to_string e);
                throw_error e)
          | _ ->
            throw_error Model.Error.Frontend.BadRequest
    );

    Dream.get "/" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in

      let _ = Dream.log "[/lists/ GET]" in
      let%lwt feed_lists = Dream.sql request (get_all_lists user_id) in
        json { feed_lists = List.map Model.FeedList.Frontend.to_frontend feed_lists } all_feed_lists_response_to_yojson
    );

    Dream.get "/:id" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in
      let id = Dream.param request "id" in

      let _ = Dream.log "[/lists/:id GET] id: %s" id in
      match%lwt Dream.sql request (get_list user_id id) with
        | Some (feed_list, feeds) ->
          json { feed_list = Model.FeedList.Frontend.to_frontend feed_list; feeds = List.map Model.Feed.Frontend.to_frontend feeds } feed_list_response_to_yojson
        | None ->
          throw_error Model.Error.Frontend.NotFound
    );

    Dream.delete "/:id" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in
      let id = Dream.param request "id" in

      let _ = Dream.log "[/lists/:id DELETE] id: %s" id in
      match%lwt Dream.sql request (delete_list user_id id) with
        | Ok _ ->
          Dream.log "[/lists/:id DELETE] id: %s - delete success" id;
          json { message = "ok" } status_response_to_yojson
        | Error e ->
          Dream.log "[/lists/:id DELETE] id: %s - delete failed with %s" id (Model.Error.Frontend.to_string e);
          throw_error e
    );

    Dream.get "/:id/items" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in
      let id = Dream.param request "id" in

      let _ = Dream.log "[/lists/:id/items GET] id: %s" id in
      match%lwt Dream.sql request (get_list_items user_id id) with
        | Some (_, items) ->
          json { items = List.map Model.Item.Frontend.to_frontend items } items_response_to_yojson
        | None ->
          throw_error Model.Error.Frontend.NotFound
    );
  ]
]
