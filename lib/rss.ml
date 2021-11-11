open Lwt
open Cohttp_lwt_unix

let fromUri uri = 
  Client.get uri >>= fun (_, body) ->
    body |> Cohttp_lwt.Body.to_string >|= fun body -> body

let run () =
  let body = Lwt_main.run (fromUri (Uri.of_string "https://hnrss.org/frontpage")) in
  print_endline ("Received body\n" ^ body)