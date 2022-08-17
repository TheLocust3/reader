type feed_response = {
  feed : Model.Feed.Frontend.t option;
} [@@deriving yojson]

type status_response = {
  message : string;
} [@@deriving yojson]

type login_response = {
  token : string;
} [@@deriving yojson]
