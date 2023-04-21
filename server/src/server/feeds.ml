open Common
open Common.Api

open Request
open Response

let create_feed source connection =
  match%lwt (Source.Rss.from_uri (Uri.of_string source)) with
    | Some document ->
      Dream.log "[create_feed] uri: %s - found %s" source document.feed.title;

      (match%lwt Database.Feeds.create document.feed connection with
        | Ok _ ->
          Dream.log "[create_feed] uri: %s - add success" source;
          Lwt.return_ok ()
        | Error e ->
          let message = Api.Error.Database.to_string e in
            Dream.log "[create_feed] uri: %s - add failed with %s" source message;
            Lwt.return (Error (Api.Error.Database.to_frontend e)))
    | None ->
      Dream.log "[create_feed] uri: %s - Not found" source;
      Lwt.return (Error Api.Error.Frontend.NotFound)

let get_feed source connection =
  match%lwt Database.Feeds.by_source source connection with
    | Ok feed ->
      Lwt.return (Some feed)
    | Error e ->
      Dream.log "[get_feed] uri: %s - lookup failed with %s" (Uri.to_string source) (Api.Error.Database.to_string e);
      let%lwt document = Source.Rss.from_uri source in
        document |> Option.map (fun (doc : Source.Rss.t) -> doc.feed) |> Lwt.return

let get_feed_items (user_id) (source) (connection) : Model.UserItem.Internal.t list option Lwt.t =
  match%lwt Database.Feeds.by_source source connection with
    | Ok _ ->
      (match%lwt Database.UserItems.feed_items_by_user_id user_id (Uri.to_string source) (Database.UserItems.Options.make ~limit: 64 ~read: None) connection with
        | Ok items ->
          Lwt.return (Some items)
        | Error e ->
          Dream.log "[get_feed_items] uri: %s - items lookup failed with %s" (Uri.to_string source) (Api.Error.Database.to_string e);
          Lwt.return None)
    | Error e ->
      Dream.log "[get_feed_items] uri: %s - feed lookup failed with %s" (Uri.to_string source) (Api.Error.Database.to_string e);
      Lwt.return None

let routes = [
  Dream.scope "/api/feeds" [Common.Middleware.cors; Common.Middleware.Auth.require_auth] [
    Dream.post "" (fun request ->
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> feed_request_of_yojson in
        match req with
          | Ok { uri } ->
            Dream.log "[/feeds POST] uri: %s" uri;
            (match%lwt Dream.sql request (create_feed uri) with
              | Ok _ ->
                Dream.log "[/feeds POST] uri: %s - add success" uri;
                json { message = "ok" } status_response_to_yojson
              | Error e ->
                Dream.log "[/feeds POST] uri: %s - add failed with %s" uri (Api.Error.Frontend.to_string e);
                throw_error e)
          | _ ->
            throw_error Api.Error.Frontend.BadRequest
    );

    Dream.get "/:source" (fun request ->
      let source = Dream.param request "source" |> Uri.of_string in

      let _ = Dream.log "[/feeds/:uri GET] uri: %s" (Uri.to_string source) in
      let%lwt feed = Dream.sql request (get_feed source) in
        match feed with
          | Some feed ->
            json { feed = Model.Feed.Frontend.to_frontend feed } feed_response_to_yojson
          | None ->
            throw_error Api.Error.Frontend.NotFound
    );

    Dream.get "/:source/items" (fun request ->
      let user_id = Dream.field request Common.Middleware.Auth.user_id |> Option.get in
      let source = Dream.param request "source" |> Uri.of_string in

      let _ = Dream.log "[/feeds/:uri/items GET] uri: %s" (Uri.to_string source) in
      let%lwt items = Dream.sql request (get_feed_items user_id source) in
        match items with
          | Some items ->
            json { items = List.map Model.UserItem.Frontend.to_frontend items } items_response_to_yojson
          | None ->
            throw_error Api.Error.Frontend.NotFound
    );
  ]
]
