open Util

module Item = struct
  type t = {
    id : string;
    title : string;
    link : string;
    description : string;
  } [@@deriving yojson]

  module Partial = struct
    type t = {
      id : string option;
      title : string option;
      link : string option;
      description : string option;
    }

    let empty = { id = None; title = None; link = None; description = None; }
  end

  let to_strict feed (partial : Partial.t) : t option =
    let* title = partial.title in
    let* link = partial.link in
    let description = Option.value partial.description ~default: "" in
    let id = Option.value partial.id ~default: ((Uri.to_string feed) ^ " " ^ link) in
    let uid = id |> Uuidm.v5 Uuidm.ns_url |> Uuidm.to_string in
      Some { id = uid; title = title; link = link; description = description }
end

type t = {
  id : string;
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
  let* items = strict_flatten(List.map(Item.to_strict source)(partial.items)) in
  let id = source |> Uri.to_string |> Uuidm.v5 Uuidm.ns_url |> Uuidm.to_string in
    Some { id = id; source = source; title = title; link = link; description = description; items = items }

type ref = string
