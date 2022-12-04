type all_feeds_response = {
  feeds : Model.Feed.Frontend.t list;
} [@@deriving yojson]

type feed_response = {
  feed : Model.Feed.Frontend.t;
} [@@deriving yojson]

type items_response = {
  items : Model.UserItem.Frontend.t list;
} [@@deriving yojson]

type all_boards_response = {
  boards : Model.Board.Frontend.t list;
} [@@deriving yojson]

type board_response = {
  board : Model.Board.Frontend.t;
} [@@deriving yojson]

type status_response = {
  message : string;
} [@@deriving yojson]

type login_response = {
  token : string;
} [@@deriving yojson]
