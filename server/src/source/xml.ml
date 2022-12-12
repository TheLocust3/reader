open Lwt
open Cohttp
open Cohttp_lwt_unix
open Markup

module StringMap = Map.Make(String)
type xml = Content of string | Node of string * string StringMap.t * xml list

let from_body parse body =
  body |> parse |> signals |> tree
    ~text: (fun ss -> Content (String.concat "" ss))
    ~element: (fun (_, name) attrs children ->
      Node (name, List.fold_left(fun acc ((_, name), value) -> 
        StringMap.add (String.lowercase_ascii name) value acc
      )(StringMap.empty)(attrs), children))

let rec from_uri parse uri = 
  Client.get uri >>= fun (response, body) ->
    match Response.status response with
      | `Permanent_redirect | `Moved_permanently ->
        let%lwt _ = Cohttp_lwt.Body.drain_body body in
        let headers = Response.headers response in
        let location = Header.get headers "location" in
          from_uri parse (location |> Option.get |> Uri.of_string)
      | _ ->
        body |> Cohttp_lwt.Body.to_string >|= fun body -> body |> string |> (from_body parse)

let xml_from_uri uri = from_uri parse_xml uri
let html_from_uri uri = from_uri parse_html uri
