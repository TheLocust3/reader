type t = {
  source : Uri.t [@to_yojson Codec.uri_to_yojson] [@of_yojson Codec.uri_of_yojson];
  name : string option;
} [@@deriving yojson]

let create uri href name =
  let sourceUri = Uri.of_string href in
  let source = (match Uri.host sourceUri with
      | Some(_) -> sourceUri
      | None -> Uri.with_path uri href) in
  { source = source; name = name }
