open Lwt
open Cohttp_lwt_unix
open Markup

type xml = Content of string | Node of string * xml list
type feed = {
  title : string
}

let show { title } = "(Feed title = " ^ title ^ ")"
let empty = { title = "" }

let fromUri uri = 
  Client.get uri >>= fun (_, body) ->
    body |> Cohttp_lwt.Body.to_string >|= fun body -> body

let fromBody body =
  body |> parse_xml |> signals |> tree
    ~text: (fun ss -> Content (String.concat "" ss))
    ~element: (fun (_, name) _ children -> Node (name, children))

let fromXml = function
  Node ("rss", [Node ("channel", children)]) ->
   Some (List.fold_left(fun feed child -> match child with
     | Node ("title", [Content title]) -> { title = title }
     | _ -> feed
   )(empty)(children))
  | _ -> None

let feedFromUri uri = 
  fromUri uri >|= fun (body) ->
    let feed = body |> string |> fromBody |> Option.map(fromXml) |> Option.join in
    print_endline (show (Option.get feed));
    ()

let run () =
  let _ = Lwt_main.run (feedFromUri (Uri.of_string "https://hnrss.org/frontpage")) in
  ()