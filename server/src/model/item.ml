open Magic

module Internal = struct
  type t = {
    id : string;
    from_feed : Uri.t;
    link : Uri.t;
    title : string;
    description : string;
  }
  type strict = t

  module Partial = struct
    type t = {
      id : string option;
      title : string option;
      link : Uri.t option;
      description : string option;
    }

    let empty = { id = None; title = None; link = None; description = None; }
  end

  let to_strict from_feed (partial : Partial.t) : t option =
    let* title = partial.title in
    let* link = partial.link in
    let description = Option.value partial.description ~default: "" in
    let id = Option.value partial.id ~default: ((Uri.to_string from_feed) ^ "_" ^ (Uri.to_string link)) in
      Some { id = id; from_feed = from_feed; title = title; link = link; description = description }    
end

module Frontend = struct
  type t = {
    id : string;
    from_feed : Uri.t [@to_yojson Codec.uri_to_yojson] [@of_yojson Codec.uri_of_yojson];
    link : Uri.t [@to_yojson Codec.uri_to_yojson] [@of_yojson Codec.uri_of_yojson];
    title : string;
    description : string;
  } [@@deriving yojson]

  let to_frontend ({ id; from_feed; link; title; description } : Internal.t) =
    { id = id; from_feed = from_feed; link = link; title = title; description = description }
end
