open Lwt

module Source = struct
  module StringSet = Set.Make(String)
  type setEncoding = string list [@@deriving yojson]
  let set_to_yojson set = setEncoding_to_yojson @@ StringSet.elements set
  let set_of_yojson json = 
    Result.(match setEncoding_of_yojson json with
              | Ok set -> Ok (StringSet.of_list(set))
              | Error s -> Error s)
  type string_set = StringSet.t [@to_yojson set_to_yojson]
                       [@of_yojson set_of_yojson]
                       [@@deriving yojson]

  type t = {
    uri : string;
    links : string_set;
  } [@@deriving yojson]

  let empty uri = { uri = uri; links = StringSet.empty }
  let withLink link source = (match (link |> Uri.of_string |> Uri.host) with
    | Some(host) -> { source with links = StringSet.add host source.links }
    | None -> source)

  let rec fromXml source = function
    Xml.Node ("a", attrs, _) ->
      (match (Option.map(fun link -> withLink link source)(Xml.StringMap.find_opt "href" attrs)) with
      | Some source -> source
      | None -> source)
  | Xml.Node (_, _, children) ->
    List.fold_left(fromXml)(source)(children)
  | Xml.Content _ ->
    source
end

let scrape uri =
  Xml.htmlFromUri uri >|= fun (root) ->
    root |> Option.map(Source.fromXml (Source.empty (Uri.to_string uri)))
