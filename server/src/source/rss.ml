open Lwt
open Magic.Let

type t = {
  feed : Model.Feed.Internal.t;
  items : Model.Item.Internal.t list;
}

module Partial = struct
  type t = {
    feed : Model.Feed.Internal.Partial.t;
    items : Model.Item.Internal.Partial.t list;
  }

  let withFeed document feed =
    { document with feed = feed }

  let withItems document items =
    { document with items = items }

  let build source =
    { feed = Model.Feed.Internal.Partial.build source; items = [] }
end

let to_strict (partial : Partial.t) : t option =
  let* feed = Model.Feed.Internal.to_strict partial.feed in
  let items = partial.items |> List.map (Model.Item.Internal.to_strict feed.source) |> Magic.List.flatten_option in
    Some { feed = feed; items = items }

module ToItem = struct
  open Model.Item.Internal.Partial

  let from_xml = function
    Xml.Node ("item", _, children) ->
      Some (List.fold_left(fun item child -> match child with
       | Xml.Node ("title", _, [Xml.Content title]) -> { item with title = Some title }
       | Xml.Node ("link", _, [Xml.Content link]) -> { item with link = Some (Uri.of_string link) }
       | Xml.Node ("description", _, [Xml.Content description]) -> { item with description = Some description }
       | Xml.Node ("guid", _, [Xml.Content guid]) -> { item with id = Some guid }
       | _ -> item
    )(empty)(children))
  | _ -> None
end

module ToFeed = struct
  open Model.Feed.Internal.Partial

  let from_xml document = function
    | Xml.Node ("rss", _, children) ->
      let items = children |> List.concat_map (fun child -> match child with
        | Xml.Node ("channel", _, items) -> items
        | _ -> []
      ) in
      Some (List.fold_left(fun document child -> match child with
        | Xml.Node ("title", _, [Xml.Content title]) -> Partial.withFeed document { document.feed with title = Some title }
        | Xml.Node ("link", _, [Xml.Content link]) -> Partial.withFeed document { document.feed with link = Some (Uri.of_string link) }
        | Xml.Node ("description", _, [Xml.Content description]) -> Partial.withFeed document { document.feed with description = Some description }
        | Xml.Node ("item", _, _) as node -> Partial.withItems document (Option.get (ToItem.from_xml(node)) :: document.items)
        | _ -> document
      )(document)(items))
    | _ -> None
end

let from_uri uri = 
  (Xml.xml_from_uri uri) >|= fun (body) -> (* TODO: JK could add some real error handling here *)
    body |> Option.map(uri |> Partial.build |> ToFeed.from_xml) |> Option.join |> Option.map(to_strict) |> Option.join
