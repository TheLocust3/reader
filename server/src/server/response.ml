type feed_response = {
  feed : Model.Feed.Frontend.t;
} [@@deriving yojson]

type items_response = {
  items : Model.Item.Frontend.t list;
} [@@deriving yojson]

type status_response = {
  message : string;
} [@@deriving yojson]

type login_response = {
  token : string;
} [@@deriving yojson]
