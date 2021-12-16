open Lwt

module ToItem = struct
  open Model.Feed.Item

  let from_xml = function
    Xml.Node ("item", _, children) ->
      Some (List.fold_left(fun item child -> match child with
       | Xml.Node ("title", _, [Xml.Content title]) -> { item with title = title }
       | Xml.Node ("link", _, [Xml.Content link]) -> { item with link = link }
       | Xml.Node ("description", _, [Xml.Content description]) -> { item with description = description }
       | _ -> item
    )(empty)(children))
  | _ -> None
end

module ToFeed = struct
  open Model.Feed

  let from_xml = function
    Xml.Node ("rss", _, [Xml.Node ("channel", _, children)]) ->
     Some (List.fold_left(fun feed child -> match child with
       | Xml.Node ("title", _, [Xml.Content title]) -> { feed with title = title }
       | Xml.Node ("link", _, [Xml.Content link]) -> { feed with link = link }
       | Xml.Node ("description", _, [Xml.Content description]) -> { feed with description = description }
       | Xml.Node ("item", _, _) as node -> { feed with items = Option.get (ToItem.from_xml(node)) :: feed.items }
       | _ -> feed
    )(empty)(children))
  | _ -> None
end

let from_uri uri = 
  Xml.xml_from_uri uri >|= fun (body) ->
    body |> Option.map(ToFeed.from_xml) |> Option.join
