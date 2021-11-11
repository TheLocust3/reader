open Lwt
open Cohttp_lwt_unix
open Markup

type xml = Content of string | Node of string * xml list
type feed = {
  title : string
}

let show { title } = "(Feed title = " ^ title ^ ")"

let fromUri uri = 
  Client.get uri >>= fun (_, body) ->
    body |> Cohttp_lwt.Body.to_string >|= fun body -> body

let fromBody body =
  body |> parse_xml |> signals |> tree
    ~text: (fun ss -> Content (String.concat "" ss))
    ~element: (fun (_, name) _ children -> Node (name, children))

let fromXml _ = Some { title = "test" }

let feedFromUri uri = 
  fromUri uri >|= fun (body) ->
    let feed = body |> string |> fromBody |> fromXml in
    print_endline (show (Option.get feed));
    ()

let run () =
  let _ = Lwt_main.run (feedFromUri (Uri.of_string "https://hnrss.org/frontpage")) in
  ()