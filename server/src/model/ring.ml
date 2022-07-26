open Codec

type t = {
  uri : Uri.t [@to_yojson Codec.uri_to_yojson] [@of_yojson Codec.uri_of_yojson];
  links : string_set;
} [@@deriving yojson]

let empty uri = { uri = uri; links = StringSet.empty }

let with_link link source = (match (link |> Uri.of_string |> Uri.host) with
  | Some(host) -> { source with links = StringSet.add host source.links }
  | None -> source)