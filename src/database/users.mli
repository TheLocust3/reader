val migrate : Caqti_lwt.connection -> unit Lwt.t
val rollback : Caqti_lwt.connection -> unit Lwt.t

val by_email : string -> Caqti_lwt.connection -> (Model.User.t, Error.t) result Lwt.t
val create : Model.User.t -> Caqti_lwt.connection -> (unit, Error.t) result Lwt.t
