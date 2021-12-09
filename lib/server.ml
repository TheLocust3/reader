open Lwt

type feed_request = {
  uri : string;
} [@@deriving yojson]

type feed_response = {
  feed : Rss.Feed.feed option;
} [@@deriving yojson]

type scrape_request = {
  uri : string;
} [@@deriving yojson]

type scrape_response = {
  source : Scraper.Source.source;
} [@@deriving yojson]

let run () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [

    Dream.post "/feed/read" (fun request ->
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> feed_request_of_yojson in
        match req with
          | Ok { uri } ->
            (Rss.fromUri (Uri.of_string uri)) >>= (fun (feed) ->
              { feed = feed } |> feed_response_to_yojson |> Yojson.Safe.to_string |> Dream.json
            )
          | _ ->
            Dream.empty `Bad_Request
    );

    Dream.post "/ring/scrape" (fun request ->
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> scrape_request_of_yojson in
        match req with
          | Ok { uri } ->
            (Scraper.scrape (Uri.of_string uri)) >>= (fun (source) ->
              { source = source } |> scrape_response_to_yojson |> Yojson.Safe.to_string |> Dream.json
            )
          | _ ->
            Dream.empty `Bad_Request
    );
  ]
  @@ Dream.not_found