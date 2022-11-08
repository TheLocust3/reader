module Internal = struct
  type t = {
    id : string;
    user_id : string;
    name : string;
  }

  module WithFeeds = struct
    type t = {
      id : string;
      user_id : string;
      name : string;
      feeds : Feed.Internal.t list;
    }
  end
end

module Frontend = struct
  type t = {
    id : string;
    user_id : string;
    name : string;
  } [@@deriving yojson]

  let to_frontend ({ id; user_id; name } : Internal.t) =
    { id = id; user_id = user_id; name = name }

  module WithFeeds = struct
    type t = {
      id : string;
      user_id : string;
      name : string;
      feeds : Feed.Frontend.t list;
    } [@@deriving yojson]

    let to_frontend ({ id; user_id; name; feeds } : Internal.WithFeeds.t) =
      { id = id; user_id = user_id; name = name; feeds = List.map Feed.Frontend.to_frontend feeds }
  end
end
