type t = {
  id : string;
  email : string;
  password : Bcrypt.hash;
}

let build ~email ~password =
  let id = email |> Uuidm.v5 Uuidm.ns_url |> Uuidm.to_string in
  let hashed = password |> Bcrypt.hash in
    { id = id; email = email; password = hashed }

let verify tryPassword { id = _; email = _; password } =
  Bcrypt.verify tryPassword password
