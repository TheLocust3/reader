open Model
open Model.UserItem.Database

let make ~user_id ~item_id ~read =
  { user_id = user_id; item_id = item_id; read = read }

module Internal = struct
  open Model.UserItem.Internal

  module Metadata = struct
    open Model.UserItem.Internal.Metadata

    let make ~read =
      { read = read }
  end

  let make (item, metadata) =
    { item = item; metadata = metadata }
end

module Options = struct
  type t = {
    limit : int;
    read : bool option;
  }

  let empty = { limit = -1; read = None }
  let make ~limit ~read = { limit = limit; read = read }
end

let migrate_query = [%rapper
  execute {sql|
    CREATE TABLE user_items (
      user_id TEXT NOT NULL,
      item_id TEXT NOT NULL,
      read BOOLEAN NOT NULL,
      FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY(item_id) REFERENCES items(id) ON DELETE CASCADE,
      PRIMARY KEY(user_id, item_id)
    )
  |sql}
  syntax_off
]

let rollback_query = [%rapper
  execute {sql|
    DROP TABLE user_items
  |sql}
  syntax_off
]

let set_read_query = [%rapper
  execute {sql|
    INSERT INTO user_items (user_id, item_id, read)
    VALUES (%string{user_id}, %string{item_id}, %bool{read})
    ON CONFLICT (user_id, item_id)
    DO UPDATE SET read=excluded.read
  |sql}
  syntax_off
]

let delete_query = [%rapper
  execute {sql|
    DELETE FROM user_items
    WHERE user_id = %string{user_id} AND item_id = %string{item_id}
  |sql}
  syntax_off
]

let all_items_by_user_id_query = [%rapper
  get_many {sql|
    SELECT @string{items.id}, @string{items.from_feed}, @string{items.link}, @string{items.title}, @string{items.description}, IFNULL(@bool{user_items.read}, FALSE)
    FROM user_feeds, items
    LEFT JOIN user_items ON user_items.user_id = %string{user_id} AND items.id = user_items.item_id
    WHERE
      IIF(%bool{unread_only}, user_items.read = FALSE OR user_items.read IS NULL, TRUE) AND
      IIF(%bool{read_only}, user_items.read = TRUE, TRUE) AND
      user_feeds.user_id = %string{user_id} AND
      user_feeds.feed_id = items.from_feed
    ORDER BY items.created_at DESC
    LIMIT %int{limit}
  |sql}
  function_out
  syntax_off
](Items.make, Internal.Metadata.make)

let board_items_by_user_id_query = [%rapper
  get_many {sql|
    SELECT @string{items.id}, @string{items.from_feed}, @string{items.link}, @string{items.title}, @string{items.description}, IFNULL(@bool{user_items.read}, FALSE)
    FROM board_entries, items
    LEFT JOIN user_items ON user_items.user_id = %string{user_id} AND items.id = user_items.item_id
    WHERE
      IIF(%bool{unread_only}, user_items.read = FALSE OR user_items.read IS NULL, TRUE) AND
      IIF(%bool{read_only}, user_items.read = TRUE, TRUE) AND
      board_entries.board_id = %string{board_id} AND
      board_entries.item_id = items.id
    ORDER BY items.created_at DESC
    LIMIT %int{limit}
  |sql}
  function_out
  syntax_off
](Items.make, Internal.Metadata.make)

let feed_items_by_user_id_query = [%rapper
  get_many {sql|
    SELECT @string{items.id}, @string{items.from_feed}, @string{items.link}, @string{items.title}, @string{items.description}, IFNULL(@bool{user_items.read}, FALSE)
    FROM items
    LEFT JOIN user_items ON user_items.user_id = %string{user_id} AND items.id = user_items.item_id
    WHERE
      IIF(%bool{unread_only}, user_items.read = FALSE OR user_items.read IS NULL, TRUE) AND
      IIF(%bool{read_only}, user_items.read = TRUE, TRUE) AND
      items.from_feed = %string{from_feed}
    ORDER BY items.created_at DESC
    LIMIT %int{limit}
  |sql}
  function_out
  syntax_off
](Items.make, Internal.Metadata.make)

let garbage_collect_query = [%rapper
  get_opt {sql|
    SELECT @string{items.id}, @string{items.from_feed}, @string{items.link}, @string{items.title}, @string{items.description}
    FROM items
    LEFT JOIN user_items ON user_items.item_id = items.id
    WHERE user_items.item_id IS NULL AND items.created_at < datetime('now', '-7 days')
    ORDER BY items.created_at DESC
    LIMIT 1
  |sql}
  function_out
  syntax_off
](Items.make)

let migrate connection =
  let query = migrate_query() in
    query connection |> Error.Database.or_print

let rollback connection =
  let query = rollback_query() in
    query connection |> Error.Database.or_print

let set_read user_id item_id connection =
  let query = set_read_query ~user_id: user_id ~item_id: item_id ~read: true in
    query connection |> Error.Database.or_error

let delete user_id item_id connection =
  let query = delete_query ~user_id: user_id ~item_id: item_id in
    query connection |> Error.Database.or_error

open Options
let all_items_by_user_id user_id { limit; read } connection =
  let query = all_items_by_user_id_query ~user_id: user_id ~limit: limit ~unread_only: (not (Option.value read ~default: true)) ~read_only: (Option.value read ~default: false) in
    query connection |> Error.Database.or_error |> Lwt.map (Result.map (List.map Internal.make))

let board_items_by_user_id user_id board_id { limit; read } connection =
  let query = board_items_by_user_id_query ~user_id: user_id ~board_id: board_id ~limit: limit ~unread_only: (not (Option.value read ~default: true)) ~read_only: (Option.value read ~default: false) in
    query connection |> Error.Database.or_error |> Lwt.map (Result.map (List.map Internal.make))

let feed_items_by_user_id user_id feed_id { limit; read } connection =
  let query = feed_items_by_user_id_query ~user_id: user_id ~from_feed: feed_id ~limit: limit ~unread_only: (not (Option.value read ~default: true)) ~read_only: (Option.value read ~default: false) in
    query connection |> Error.Database.or_error |> Lwt.map (Result.map (List.map Internal.make))

let garbage_collect connection =
  let query = garbage_collect_query() in
    query connection |> Error.Database.or_error
