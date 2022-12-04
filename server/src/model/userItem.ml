module Database = struct
  type t = {
    user_id : string;
    item_id : string;
    read : bool;
  }
end

module Internal = struct
  module Metadata = struct
    type t = {
      read : bool;
    }
  end

  type t = {
    item : Item.Internal.t;
    metadata : Metadata.t;
  }
end

module Frontend = struct
  module Metadata = struct
    type t = {
      read : bool;
    } [@@deriving yojson]

    let to_frontend ({ read } : Internal.Metadata.t) =
      { read = read }
  end

  type t = {
    item : Item.Frontend.t;
    metadata : Metadata.t;
  } [@@deriving yojson]

  let to_frontend ({ item; metadata } : Internal.t) =
    { item = Item.Frontend.to_frontend item; metadata = Metadata.to_frontend metadata }
end
