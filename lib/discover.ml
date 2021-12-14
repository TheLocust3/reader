open Lwt

module Source = struct
  type t = {
    source : string;
    name : string option;
  } [@@deriving yojson]

  let (let*) x f = Option.bind x f
  let filter_opt f x = List.nth_opt(List.filter(f)(Option.to_list x))(0)

  let rec from_xml feeds = function
    Xml.Node ("link", attrs, _) ->
      Option.to_list
        (let* _ = Xml.StringMap.find_opt "rel" attrs |> filter_opt(fun value -> value = "alternate") in
        let* _ = Xml.StringMap.find_opt "type" attrs |> filter_opt(fun value -> value = "application/rss+xml") in
        let* href = Xml.StringMap.find_opt "href" attrs in
        Some { source = href; name = (Xml.StringMap.find_opt "name" attrs) })
      @ feeds
  | Xml.Node (_, _, children) ->
    List.fold_left(from_xml)(feeds)(children)
  | Xml.Content _ ->
    feeds
end

let discover uri =
  Xml.html_from_uri uri >|= fun (root) ->
    root |> Option.map(Source.from_xml []) |> Option.to_list |> List.flatten
