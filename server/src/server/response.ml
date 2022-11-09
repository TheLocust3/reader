type feed_response = {
  feed : Model.Feed.Frontend.t;
} [@@deriving yojson]

type items_response = {
  items : Model.Item.Frontend.t list;
} [@@deriving yojson]

type all_feed_lists_response = {
  feed_lists : Model.FeedList.Frontend.t list;
} [@@deriving yojson]

type feed_list_response = {
  feed_list : Model.FeedList.Frontend.t;
  feeds : Model.Feed.Frontend.t list;
} [@@deriving yojson]

type status_response = {
  message : string;
} [@@deriving yojson]

type login_response = {
  token : string;
} [@@deriving yojson]
