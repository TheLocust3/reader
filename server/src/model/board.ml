module Internal = struct
  type t = {
    id : string;
    user_id : string;
    name : string;
  }

  let build ~user_id ~name =
    let _ = Random.bool () in (* move the Random state forward before uuid gen *)
    let id = Uuidm.v4_gen(Random.get_state())() |> Uuidm.to_string in
      { id = id; user_id = user_id; name = name }
end

module Frontend = struct
  type t = {
    id : string;
    user_id : string;
    name : string;
  } [@@deriving yojson]
  
  let to_frontend ({ id; user_id; name } : Internal.t) =
    { id = id; user_id = user_id; name = name }
end
