type feed_request = {
  uri : string;
} [@@deriving yojson]

type login_request = {
  email : string;
  password : string;
} [@@deriving yojson]
