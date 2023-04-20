open Lwt
open Model.Source
open Common.Magic.Let

module ToSource = struct
  let filter_opt f x = List.nth_opt(List.filter(f)(Option.to_list x))(0)

  let rec from_xml uri feeds = function
    Xml.Node ("link", attrs, _) ->
      Option.to_list
        (let* _ = Xml.StringMap.find_opt "rel" attrs |> filter_opt(fun value -> value = "alternate") in
        let* _ = Xml.StringMap.find_opt "type" attrs |> filter_opt(fun value -> value = "application/rss+xml") in
        let* href = Xml.StringMap.find_opt "href" attrs in
        Some (create uri href (Xml.StringMap.find_opt "title" attrs)))
      @ feeds
  | Xml.Node (_, _, children) ->
    List.fold_left(from_xml uri)(feeds)(children)
  | Xml.Content _ ->
    feeds
end

let discover uri =
  Xml.html_from_uri uri >|= fun (root) ->
    root |> Option.map(ToSource.from_xml uri []) |> Option.to_list |> List.flatten
