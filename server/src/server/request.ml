type feed_request = {
  uri : string;
} [@@deriving yojson]

type board_create_request = {
  name : string;
} [@@deriving yojson]

type user_feed_add_request = {
  uri : string;
} [@@deriving yojson]

type login_request = {
  email : string;
  password : string;
} [@@deriving yojson]
