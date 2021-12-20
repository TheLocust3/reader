module Item = struct
  type t = {
    title : string;
    link : string;
    description : string;
  } [@@deriving yojson]

  let empty = { title = ""; link = ""; description = ""; }
end

type t = {
  source: Uri.t [@to_yojson Codec.uri_to_yojson] [@of_yojson Codec.uri_of_yojson];
  title : string;
  link : Uri.t [@to_yojson Codec.uri_to_yojson] [@of_yojson Codec.uri_of_yojson];
  description : string;
  items : Item.t list;
} [@@deriving yojson]

let create source = { source = source; title = ""; link = Uri.of_string ""; description = ""; items = []; }
