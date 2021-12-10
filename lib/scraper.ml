open Lwt

module Source = struct
  type t = {
    uri : string;
    links : string list;
  } [@@deriving yojson]

  let empty uri = { uri = uri; links = [] }

  let rec fromXml source = function
    Xml.Node ("a", attrs, _) ->
      (match (Option.map(fun link -> { source with links = link :: source.links })(Xml.StringMap.find_opt "href" attrs)) with
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
