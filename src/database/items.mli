val migrate : unit -> unit Lwt.t
val rollback : unit -> unit Lwt.t

val by_feed : Caqti_lwt.connection -> Model.Feed.ref -> (Model.Feed.Item.t list, Error.t) result Lwt.t
val create : Caqti_lwt.connection -> Model.Feed.Item.t -> Model.Feed.ref -> (unit, Error.t) result Lwt.t