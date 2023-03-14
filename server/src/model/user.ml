open Magic.Let

module Internal = struct
  type t = {
    id : string;
    email : string;
    password : Bcrypt.hash;
  }

  let build ~email ~password =
    let _ = Random.bool () in (* move the Random state forward before uuid gen *)
    let id = email |> Uuidm.v5 Uuidm.ns_url |> Uuidm.to_string in
    let hashed = password |> Bcrypt.hash in
      { id = id; email = email; password = hashed }

  let verify tryPassword { id = _; email = _; password } =
    Bcrypt.verify tryPassword password

  type payload = {
    user_id : string;
    expires : int;
  } [@@deriving yojson]

  let sign jwk { id = id; email = _; password = _ } =
    let header = Jose.Header.make_header ~typ:"JWT" jwk in
    let expires = int_of_float(Unix.time()) + (60 * 60) in (* 1 hour *)
    let payload = { user_id = id; expires = expires } |> payload_to_yojson in
      Jose.Jwt.sign ~header ~payload jwk |> Result.map(Jose.Jwt.to_string) |> Result.value ~default: ""

  let validate jwk token =
    let** jwt : Jose.Jwt.t = token
    |> Jose.Jwt.of_string ~jwk ~now: (Ptime_clock.now ()) in
      match payload_of_yojson jwt.payload with
        | Ok { user_id; expires } ->
          if int_of_float(Unix.time()) > expires
          then Error `Expired
          else Ok user_id
        | Error e -> Error (`Msg e)
end

module Frontend = struct
  type t = {
    id : string;
    email : string;
  } [@@deriving yojson]
end
