open Lwt
open Model.Ring

module ToRing = struct
  let rec from_xml source = function
    Xml.Node ("a", attrs, _) ->
      (match (Option.map(fun link -> with_link link source)(Xml.StringMap.find_opt "href" attrs)) with
      | Some source -> source
      | None -> source)
  | Xml.Node (_, _, children) ->
    List.fold_left(from_xml)(source)(children)
  | Xml.Content _ ->
    source
end

let scrape uri =
  Xml.html_from_uri uri >|= fun (root) ->
    root |> Option.map(ToRing.from_xml (Model.Ring.empty (Uri.to_string uri)))
