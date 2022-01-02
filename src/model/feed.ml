open Util

module Item = struct
  type t = {
    title : string;
    link : string;
    description : string;
  } [@@deriving yojson]

  module Partial = struct
    type t = {
      title : string option;
      link : string option;
      description : string option;
    }

    let empty = { title = None; link = None; description = None; }
  end

  let to_strict (partial : Partial.t) : t option =
    let* title = partial.title in
    let* link = partial.link in
    let description = Option.value partial.description ~default: "" in
      Some { title = title; link = link; description = description }
end

type t = {
  source : Uri.t [@to_yojson Codec.uri_to_yojson] [@of_yojson Codec.uri_of_yojson];
  title : string;
  link : Uri.t [@to_yojson Codec.uri_to_yojson] [@of_yojson Codec.uri_of_yojson];
  description : string;
  items : Item.t list;
} [@@deriving yojson]

module Partial = struct
  type t = {
    source : Uri.t;
    title : string option;
    link : Uri.t option;
    description : string option;
    items : Item.Partial.t list;
  }

  let build source = { source = source; title = None; link = None; description = None; items = []; }
end

let to_strict (partial : Partial.t) : t option =
  let source = partial.source in
  let* title = partial.title in
  let* link = partial.link in
  let description = Option.value partial.description ~default: "" in
  let* items = strict_flatten(List.map(Item.to_strict)(partial.items)) in
    Some { source = source; title = title; link = link; description = description; items = items }

type ref = string
