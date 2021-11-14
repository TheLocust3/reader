
type feed_request = {
  uri : string;
} [@@deriving yojson]

type feed_response = {
  feed : string;
} [@@deriving yojson]

let run () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [

    Dream.post "/feed/read" (fun request ->
      let%lwt body = Dream.body request in

      let _ = body |> Yojson.Safe.from_string |> feed_request_of_yojson
      in
        { feed = "" } |> feed_response_to_yojson |> Yojson.Safe.to_string |> Dream.json
    );
  ]
  @@ Dream.not_found