module Internal = struct
  type t = {
    source : Uri.t;
    title : string;
    link : Uri.t;
    description : string;
  }

  module Partial = struct
    type t = {
      source : Uri.t;
      title : string option;
      link : Uri.t option;
      description : string option;
    }

    let build source = { source = source; title = None; link = None; description = None; }
  end

  let to_strict (partial : Partial.t) : t option =
    let source = partial.source in
    let link = Option.value partial.link ~default: source in
    let title = Option.value partial.title ~default: (Uri.to_string link) in
    let description = Option.value partial.description ~default: "" in
      Some { source = source; title = title; link = link; description = description; }
end

module Frontend = struct
  type t = {
    source : Uri.t [@to_yojson Codec.uri_to_yojson] [@of_yojson Codec.uri_of_yojson];
    title : string;
    link : Uri.t [@to_yojson Codec.uri_to_yojson] [@of_yojson Codec.uri_of_yojson];
    description : string;
  } [@@deriving yojson]

  let to_frontend ({ source; title; link; description } : Internal.t) =
    { source = source; title = title; link = link; description = description }
end
