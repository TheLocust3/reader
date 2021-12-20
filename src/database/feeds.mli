val migrate : unit -> unit Lwt.t
val rollback : unit -> unit Lwt.t

val get_by_source : Uri.t -> (Model.Feed.t list, Error.t) result Lwt.t
