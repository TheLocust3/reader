include Lwt

let rec flatmap f l = match l with
  | first :: rest ->
    let%lwt first_val = f first in
    let%lwt rest_val = flatmap f rest in
      first_val :: rest_val |> Lwt.return
  | [] -> Lwt.return []