val migrate : unit -> unit Lwt.t
val rollback : unit -> unit Lwt.t

val create : Caqti_lwt.connection -> Model.Feed.Item.t -> Model.Feed.ref -> (unit, Error.t) result Lwt.t