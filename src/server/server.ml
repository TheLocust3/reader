open Lwt

type feed_request = {
  uri : string;
} [@@deriving yojson]

type feed_response = {
  feed : Model.Feed.t option;
} [@@deriving yojson]

type scrape_request = {
  uri : string;
} [@@deriving yojson]

type scrape_response = {
  source : Model.Ring.t option;
} [@@deriving yojson]

type discover_request = {
  uri : string;
} [@@deriving yojson]

type discover_response = {
  feeds : Model.Source.t list;
} [@@deriving yojson]

type status_response = {
  message : string;
} [@@deriving yojson]

let json ?(status = `OK) response encoder =
  response |> encoder |> Yojson.Safe.to_string |> Dream.json ~status: status

let bad_request =
  Dream.empty `Bad_Request

let run () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool Database.Connect.url
  @@ Dream.router [

    Dream.post "/feeds/insert" (fun request ->
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> feed_request_of_yojson in
        match req with
          | Ok { uri } ->
            Dream.log "[/feeds/insert] uri: %s" uri;
            (match%lwt (Source.Rss.from_uri (Uri.of_string uri)) with
              | Some feed ->
                Dream.log "[/feeds/insert] uri: %s - found %s" uri feed.title;
                (match%lwt Dream.sql request (Database.Feeds.create feed) with
                  | Ok _ ->
                    Dream.log "[/feeds/insert] uri: %s - insert success" uri;
                    json { message = "ok" } status_response_to_yojson
                  | Error e ->
                    let message = Database.Error.to_string e in
                      Dream.log "[/feeds/insert] uri: %s - insert failed with %s" uri message;
                      json ~status: `Internal_Server_Error { message = message } status_response_to_yojson)
              | None ->
                Dream.log "[/feeds/insert] uri: %s - Not found" uri;
                json ~status: `Not_Found { message = "Feed not found" } status_response_to_yojson)
          | _ ->
            bad_request
    );

    Dream.post "/feeds/read" (fun request ->
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> feed_request_of_yojson in
        match req with
          | Ok { uri } ->
            Dream.log "[/feeds/read] uri: %s" uri;
            let parsed = (Uri.of_string uri) in
            let%lwt feed = (match%lwt Dream.sql request (Database.Feeds.by_source parsed) with
                | Ok feed ->
                  Lwt.return (Some feed)
                | Error e ->
                  Dream.log "[/feeds/read] uri: %s - lookup failed with %s" uri (Database.Error.to_string e);
                  Source.Rss.from_uri parsed) in
              json { feed = feed } feed_response_to_yojson
          | _ ->
            bad_request
    );

    Dream.post "/feeds/discover" (fun request ->
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> discover_request_of_yojson in
        match req with
          | Ok { uri } ->
            Dream.log "[/feeds/discover] uri: %s" uri;
            (Source.Discover.discover (Uri.of_string uri)) >>= (fun (feeds) ->
              json { feeds = feeds } discover_response_to_yojson
            )
          | _ ->
            bad_request
    );

    Dream.post "/rings/scrape" (fun request ->
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> scrape_request_of_yojson in
        match req with
          | Ok { uri } ->
            Dream.log "[/feeds/scrape] uri: %s" uri;
            (Source.Scraper.scrape (Uri.of_string uri)) >>= (fun (source) ->
              json { source = source } scrape_response_to_yojson
            )
          | _ ->
            bad_request
    );
  ]
  @@ Dream.not_found