val migrate : unit -> unit Lwt.t
val rollback : unit -> unit Lwt.t

val by_feed : Model.Feed.ref -> Caqti_lwt.connection -> (Model.Feed.Item.t list, Error.t) result Lwt.t
val create : Model.Feed.Item.t -> Model.Feed.ref -> Caqti_lwt.connection -> (unit, Error.t) result Lwt.t