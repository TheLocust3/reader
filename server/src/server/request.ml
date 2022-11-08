type feed_request = {
  uri : string;
} [@@deriving yojson]

type list_create_request = {
  name : string;
} [@@deriving yojson]

type login_request = {
  email : string;
  password : string;
} [@@deriving yojson]
