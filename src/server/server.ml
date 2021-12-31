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
            (match%lwt (Source.Rss.from_uri (Uri.of_string uri)) with
            | Some feed ->
              (match%lwt Dream.sql request (Database.Feeds.create feed) with
              | Ok _ -> json { message = "ok" } status_response_to_yojson
              | Error e -> json ~status: `Internal_Server_Error { message = Database.Error.to_string e } status_response_to_yojson)
            | None ->
              json ~status: `Not_Found { message = "Feed not found" } status_response_to_yojson)
          | _ ->
            bad_request
    );

    Dream.post "/feeds/read" (fun request ->
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> feed_request_of_yojson in
        match req with
          | Ok { uri } ->
            (Source.Rss.from_uri (Uri.of_string uri)) >>= (fun (feed) ->
              json { feed = feed } feed_response_to_yojson
            )
          | _ ->
            bad_request
    );

    Dream.post "/feeds/discover" (fun request ->
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> discover_request_of_yojson in
        match req with
          | Ok { uri } ->
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
            (Source.Scraper.scrape (Uri.of_string uri)) >>= (fun (source) ->
              json { source = source } scrape_response_to_yojson
            )
          | _ ->
            bad_request
    );
  ]
  @@ Dream.not_found