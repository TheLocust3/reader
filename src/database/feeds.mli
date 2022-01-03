val migrate : Caqti_lwt.connection -> unit Lwt.t
val rollback : Caqti_lwt.connection -> unit Lwt.t

val by_source : Uri.t -> Caqti_lwt.connection -> (Model.Feed.t, Error.t) result Lwt.t
val create : Model.Feed.t -> Caqti_lwt.connection -> (unit, Error.t) result Lwt.t
