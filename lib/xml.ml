open Lwt
open Cohttp_lwt_unix
open Markup

module StringMap = Map.Make(String)
type xml = Content of string | Node of string * string StringMap.t * xml list

let fromBody parse body =
  body |> parse |> signals |> tree
    ~text: (fun ss -> Content (String.concat "" ss))
    ~element: (fun (_, name) attrs children ->
      Node (name, List.fold_left(fun acc ((_, name), value) -> 
        StringMap.add (String.lowercase_ascii name) value acc
      )(StringMap.empty)(attrs), children))

let fromUri parse uri = 
  Client.get uri >>= fun (_, body) ->
    body |> Cohttp_lwt.Body.to_string >|= fun body -> body |> string |> (fromBody parse)


let xmlFromUri uri = fromUri parse_xml uri
let htmlFromUri uri = fromUri parse_html uri
