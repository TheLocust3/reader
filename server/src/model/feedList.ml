module Internal = struct
  type t = {
    id : string;
    user_id : string;
    name : string;
  }
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
