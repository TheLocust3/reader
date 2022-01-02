open Lwt

module ToItem = struct
  open Model.Feed.Item.Partial

  let from_xml = function
    Xml.Node ("item", _, children) ->
      Some (List.fold_left(fun item child -> match child with
       | Xml.Node ("title", _, [Xml.Content title]) -> { item with title = Some title }
       | Xml.Node ("link", _, [Xml.Content link]) -> { item with link = Some link }
       | Xml.Node ("description", _, [Xml.Content description]) -> { item with description = Some description }
       | Xml.Node ("guid", _, [Xml.Content guid]) -> { item with id = Some guid }
       | _ -> item
    )(empty)(children))
  | _ -> None
end

module ToFeed = struct
  open Model.Feed.Partial

  let from_xml feed = function
    Xml.Node ("rss", _, [Xml.Node ("channel", _, children)]) ->
     Some (List.fold_left(fun feed child -> match child with
       | Xml.Node ("title", _, [Xml.Content title]) -> { feed with title = Some title }
       | Xml.Node ("link", _, [Xml.Content link]) -> { feed with link = Some (Uri.of_string link) }
       | Xml.Node ("description", _, [Xml.Content description]) -> { feed with description = Some description }
       | Xml.Node ("item", _, _) as node -> { feed with items = Option.get (ToItem.from_xml(node)) :: feed.items }
       | _ -> feed
    )(feed)(children))
  | _ -> None
end

let from_uri uri = 
  Xml.xml_from_uri uri >|= fun (body) -> (* TODO: JK could add some real error handling here *)
    body |> Option.map(uri |> Model.Feed.Partial.build |> ToFeed.from_xml) |> Option.join |> Option.map(Model.Feed.to_strict) |> Option.join
