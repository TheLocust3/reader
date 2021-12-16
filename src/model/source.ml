type t = {
  source : string;
  name : string option;
} [@@deriving yojson]

let create uri href name =
  let sourceUri = Uri.of_string href in
  let source = (match Uri.host sourceUri with
      | Some(_) -> Uri.to_string sourceUri
      | None -> Uri.to_string(Uri.with_path uri href)) in
  { source = source; name = name }
