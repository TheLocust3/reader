open Request
open Response
open Util

let create_board user_id name connection =
  (match%lwt Database.Boards.create (Model.Board.Internal.build ~user_id: user_id ~name: name) connection with
    | Ok _ ->
      Dream.log "[create_board] name: %s - add success" name;
      Lwt.return_ok ()
    | Error e ->
      let message = Model.Error.Database.to_string e in
        Dream.log "[create_board] name: %s - add failed with %s" name message;
        Lwt.return (Error (Model.Error.Database.to_frontend e)))

let get_all_boards user_id connection =
  match%lwt Database.Boards.by_user_id user_id connection with
    | Ok boards ->
      Lwt.return boards
    | Error e ->
      Dream.log "[get_all_boards] - lookup failed with %s" (Model.Error.Database.to_string e);
      Lwt.return []

let get_board user_id id connection =
  match%lwt Database.Boards.by_id user_id id connection with
    | Ok board ->
      Lwt.return (Some board)
    | Error e ->
      Dream.log "[get_board] id: %s - lookup failed with %s" id (Model.Error.Database.to_string e);
      Lwt.return None

let delete_board user_id id connection =
  match%lwt Database.Boards.delete user_id id connection with
    | Ok _ ->
      Lwt.return_ok ()
    | Error e ->
      let message = Model.Error.Database.to_string e in
        Dream.log "[delete_board] id: %s - add failed with %s" id message;
        Lwt.return (Error (Model.Error.Database.to_frontend e))

let get_board_items user_id id connection =
  match%lwt Database.Boards.by_id user_id id connection with
    | Ok board ->
      let%lwt _items = Database.BoardEntries.items_by_board_id id connection in
      let items = _items |> Result.to_list |> List.flatten in
        Lwt.return (Some (board, items))
    | Error e ->
      Dream.log "[get_board_items] id: %s - lookup failed with %s" id (Model.Error.Database.to_string e);
      Lwt.return None

let routes = [
  Dream.scope "/boards" [Util.Middleware.cors; Util.Middleware.require_auth] [
    Dream.post "" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in
      let%lwt body = Dream.body request in

      let req = body |> Yojson.Safe.from_string |> board_create_request_of_yojson in
        match req with
          | Ok { name } ->
            Dream.log "[/boards POST] name: %s" name;
            (match%lwt Dream.sql request (create_board user_id name) with
              | Ok _ ->
                Dream.log "[/boards POST] name: %s - add success" name;
                json { message = "ok" } status_response_to_yojson
              | Error e ->
                Dream.log "[/boards POST] name: %s - add failed with %s" name (Model.Error.Frontend.to_string e);
                throw_error e)
          | _ ->
            throw_error Model.Error.Frontend.BadRequest
    );

    Dream.get "/" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in

      let _ = Dream.log "[/boards/ GET]" in
      let%lwt boards = Dream.sql request (get_all_boards user_id) in
        json { boards = List.map Model.Board.Frontend.to_frontend boards } all_boards_response_to_yojson
    );

    Dream.get "/:id" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in
      let id = Dream.param request "id" in

      let _ = Dream.log "[/boards/:id GET] id: %s" id in
      match%lwt Dream.sql request (get_board user_id id) with
        | Some board ->
          json { board = Model.Board.Frontend.to_frontend board } board_response_to_yojson
        | None ->
          throw_error Model.Error.Frontend.NotFound
    );

    Dream.delete "/:id" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in
      let id = Dream.param request "id" in

      let _ = Dream.log "[/boards/:id DELETE] id: %s" id in
      match%lwt Dream.sql request (delete_board user_id id) with
        | Ok _ ->
          Dream.log "[/boards/:id DELETE] id: %s - delete success" id;
          json { message = "ok" } status_response_to_yojson
        | Error e ->
          Dream.log "[/boards/:id DELETE] id: %s - delete failed with %s" id (Model.Error.Frontend.to_string e);
          throw_error e
    );

    Dream.get "/:id/items" (fun request ->
      let user_id = Dream.field request Util.Middleware.user_id |> Option.get in
      let id = Dream.param request "id" in

      let _ = Dream.log "[/boards/:id/items GET] id: %s" id in
      match%lwt Dream.sql request (get_board_items user_id id) with
        | Some (_, items) ->
          json { items = List.map Model.Item.Frontend.to_frontend items } items_response_to_yojson
        | None ->
          throw_error Model.Error.Frontend.NotFound
    );
  ]
]
