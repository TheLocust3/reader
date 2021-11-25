open Lwt
open Cohttp_lwt_unix
open Markup

type xml = Content of string | Node of string * xml list

let fromBody body =
  body |> parse_xml |> signals |> tree
    ~text: (fun ss -> Content (String.concat "" ss))
    ~element: (fun (_, name) _ children -> Node (name, children))

let fromUri uri = 
  Client.get uri >>= fun (_, body) ->
    body |> Cohttp_lwt.Body.to_string >|= fun body -> body |> string |> fromBody
