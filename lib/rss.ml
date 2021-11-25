open Lwt

module Item = struct
  type item = {
    title : string;
    link : string;
    description : string;
  } [@@deriving yojson]

  let empty = { title = ""; link = ""; description = ""; }

  let fromXml = function
    Xml.Node ("item", children) ->
      Some (List.fold_left(fun item child -> match child with
       | Xml.Node ("title", [Xml.Content title]) -> { item with title = title }
       | Xml.Node ("link", [Xml.Content link]) -> { item with link = link }
       | Xml.Node ("description", [Xml.Content description]) -> { item with description = description }
       | _ -> item
    )(empty)(children))
  | _ -> None
end

module Feed = struct
  type feed = {
    title : string;
    link : string;
    description : string;
    items : Item.item list;
  } [@@deriving yojson]

  let empty = { title = ""; link = ""; description = ""; items = []; }

  let fromXml = function
    Xml.Node ("rss", [Xml.Node ("channel", children)]) ->
     Some (List.fold_left(fun feed child -> match child with
       | Xml.Node ("title", [Xml.Content title]) -> { feed with title = title }
       | Xml.Node ("link", [Xml.Content link]) -> { feed with link = link }
       | Xml.Node ("description", [Xml.Content description]) -> { feed with description = description }
       | Xml.Node ("item", _) as node -> { feed with items = Option.get (Item.fromXml(node)) :: feed.items }
       | _ -> feed
    )(empty)(children))
  | _ -> None
end

let fromUri uri = 
  Xml.fromUri uri >|= fun (body) ->
    body |> Option.map(Feed.fromXml) |> Option.join

let run () =
  let feed = Lwt_main.run (fromUri (Uri.of_string "https://hnrss.org/frontpage")) in
  Format.printf "Read feed:\n%a" Yojson.Safe.pp (feed |> Option.get |> Feed.feed_to_yojson);
  ()
