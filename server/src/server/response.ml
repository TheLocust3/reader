type feed_response = {
  feed : Model.Feed.t option;
} [@@deriving yojson]

type discover_response = {
  feeds : Model.Source.t list;
} [@@deriving yojson]

type status_response = {
  message : string;
} [@@deriving yojson]

type login_response = {
  token : string;
} [@@deriving yojson]
