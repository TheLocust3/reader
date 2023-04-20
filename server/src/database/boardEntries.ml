open Common.Api

open Model.BoardEntry.Internal

let make ~board_id ~item_id =
  { board_id = board_id; item_id = item_id }

let migrate_query = [%rapper
  execute {sql|
    CREATE TABLE board_entries (
      board_id TEXT NOT NULL,
      item_id TEXT NOT NULL,
      FOREIGN KEY(board_id) REFERENCES boards(id) ON DELETE CASCADE,
      FOREIGN KEY(item_id) REFERENCES items(id) ON DELETE CASCADE,
      PRIMARY KEY(board_id, item_id)
    )
  |sql}
  syntax_off
]

let rollback_query = [%rapper
  execute {sql|
    DROP TABLE board_entries
  |sql}
  syntax_off
]

let create_query = [%rapper
  execute {sql|
    INSERT INTO board_entries (board_id, item_id)
    VALUES (%string{board_id}, %string{item_id})
  |sql}
  syntax_off
]

let delete_query = [%rapper
  execute {sql|
    DELETE FROM board_entries
    WHERE board_id = %string{board_id} AND item_id = %string{item_id}
  |sql}
  syntax_off
]

let items_by_board_id_query = [%rapper
  get_many {sql|
    SELECT @string{items.id}, @string{items.from_feed}, @string{items.link}, @string{items.title}, @string{items.description}
    FROM board_entries, items
    WHERE board_entries.board_id = %string{board_id} AND board_entries.item_id = items.id
    ORDER BY items.created_at DESC
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

let create { board_id; item_id } connection =
  let query = create_query ~board_id: board_id ~item_id: item_id in
    query connection |> Error.Database.or_error

let delete { board_id; item_id } connection =
  let query = delete_query ~board_id: board_id ~item_id: item_id in
    query connection |> Error.Database.or_error

let items_by_board_id board_id connection =
  let query = items_by_board_id_query ~board_id: board_id in
    query connection |> Error.Database.or_error
