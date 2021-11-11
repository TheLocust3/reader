open Lwt
open Cohttp_lwt_unix
open Markup

let fromUri uri = 
  Client.get uri >>= fun (_, body) ->
    body |> Cohttp_lwt.Body.to_string >|= fun body -> body

let fromXml body =
  body |> parse_xml |> signals

let feedFromUri uri = 
  fromUri uri >|= fun (body) ->
    let feed = fromXml (string body) in
    print_endline ("Parsed feed\n" ^ (feed |> pretty_print |> write_xml |> to_string));
    ()

let run () =
  let _ = Lwt_main.run (feedFromUri (Uri.of_string "https://hnrss.org/frontpage")) in
  ()