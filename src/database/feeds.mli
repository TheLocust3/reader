val migrate : unit -> unit Lwt.t
val rollback : unit -> unit Lwt.t

val by_source : Caqti_lwt.connection -> Uri.t -> (Model.Feed.t, Error.t) result Lwt.t
val create : Caqti_lwt.connection -> Model.Feed.t -> (unit, Error.t) result Lwt.t
