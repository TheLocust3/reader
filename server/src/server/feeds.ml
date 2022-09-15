open Magic

open Request
open Response
open Util

let create_feed source connection =
  match%lwt (Source.Rss.from_uri (Uri.of_string source)) with
    | Some document ->
      Dream.log "[create_feed] uri: %s - found %s" source document.feed.title;

      (match%lwt Database.Feeds.create document.feed connection with
        | Ok _ ->
          Dream.log "[create_feed] uri: %s - add success" source;
          Lwt.return_ok ()
        | Error e ->
          let message = Model.Error.Database.to_string e in
            Dream.log "[create_feed] uri: %s - add failed with %s" source message;
            Lwt.return (Error (Model.Error.Database.to_frontend e)))
    | None ->
      Dream.log "[create_feed] uri: %s - Not found" source;
      Lwt.return (Error Model.Error.Frontend.NotFound)

let get_feed source connection =
  match%lwt Database.Feeds.by_source source connection with
    | Ok feed ->
      Lwt.return (Some feed)
    | Error e ->
      Dream.log "[get_feed] uri: %s - lookup failed with %s" (Uri.to_string source) (Model.Error.Database.to_string e);
      let%lwt document = Source.Rss.from_uri source in
        document |> Option.map (fun (doc : Source.Rss.t) -> doc.feed) |> Lwt.return

let get_feed_items source connection =
  match%lwt Database.Feeds.by_source source connection with
    | Ok _ ->
      (match%lwt Database.Items.by_feed (Uri.to_string source) connection with
        | Ok items ->
          Lwt.return (Some items)
        | Error e ->
          Dream.log "[get_feed_items] uri: %s - items lookup failed with %s" (Uri.to_string source) (Model.Error.Database.to_string e);
          Lwt.return None)
    | Error e ->
      Dream.log "[get_feed_items] uri: %s - feed lookup failed with %s" (Uri.to_string source) (Model.Error.Database.to_string e);
      let%lwt document = Source.Rss.from_uri source in
        document |> Option.map (fun (doc : Source.Rss.t) -> doc.items) |> Lwt.return

let routes = [
  Dream.scope "/feeds" [Util.Middleware.require_auth] [
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
                Dream.log "[/feeds POST] uri: %s - add failed with %s" uri (Model.Error.Frontend.to_string e);
                throw_error e)
          | _ ->
            throw_error Model.Error.Frontend.BadRequest
    );

    Dream.get "/:source" (fun request ->
      let source = Dream.param request "source" |> Uri.of_string in

      let _ = Dream.log "[/feeds/:uri GET] uri: %s" (Uri.to_string source) in
      let%lwt feed = Dream.sql request (get_feed source) in
        match feed with
          | Some feed ->
            json { feed = Model.Feed.Frontend.to_frontend feed } feed_response_to_yojson
          | None ->
            throw_error Model.Error.Frontend.NotFound
    );

    Dream.get "/:source/items" (fun request ->
      let source = Dream.param request "source" |> Uri.of_string in

      let _ = Dream.log "[/feeds/:uri/items GET] uri: %s" (Uri.to_string source) in
      let%lwt items = Dream.sql request (get_feed_items source) in
        match items with
          | Some items ->
            json { items = List.map Model.Item.Frontend.to_frontend items } items_response_to_yojson
          | None ->
            throw_error Model.Error.Frontend.NotFound
    );
  ]
]
