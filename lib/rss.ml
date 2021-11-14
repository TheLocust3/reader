open Lwt
open Cohttp_lwt_unix
open Markup

type xml = Content of string | Node of string * xml list

module Item = struct
  type item = {
    title : string;
    link : string;
    description : string;
  } [@@deriving yojson]

  let empty = { title = ""; link = ""; description = ""; }

  let fromXml = function
    Node ("item", children) ->
      Some (List.fold_left(fun item child -> match child with
       | Node ("title", [Content title]) -> { item with title = title }
       | Node ("link", [Content link]) -> { item with link = link }
       | Node ("description", [Content description]) -> { item with description = description }
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
    Node ("rss", [Node ("channel", children)]) ->
     Some (List.fold_left(fun feed child -> match child with
       | Node ("title", [Content title]) -> { feed with title = title }
       | Node ("link", [Content link]) -> { feed with link = link }
       | Node ("description", [Content description]) -> { feed with description = description }
       | Node ("item", _) as node -> { feed with items = Option.get (Item.fromXml(node)) :: feed.items }
       | _ -> feed
    )(empty)(children))
  | _ -> None
end

let fromUri uri = 
  Client.get uri >>= fun (_, body) ->
    body |> Cohttp_lwt.Body.to_string >|= fun body -> body

let fromBody body =
  body |> parse_xml |> signals |> tree
    ~text: (fun ss -> Content (String.concat "" ss))
    ~element: (fun (_, name) _ children -> Node (name, children))

let feedFromUri uri = 
  fromUri uri >|= fun (body) ->
    let feed = body |> string |> fromBody |> Option.map(Feed.fromXml) |> Option.join in
    feed

let run () =
  let feed = Lwt_main.run (feedFromUri (Uri.of_string "https://hnrss.org/frontpage")) in
  Format.printf "Read feed:\n%a" Yojson.Safe.pp (feed |> Option.get |> Feed.feed_to_yojson);
  ()