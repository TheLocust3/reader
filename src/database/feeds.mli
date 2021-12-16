val migrate : unit -> (unit, Error.t) result Lwt.t
val rollback : unit -> (unit, Error.t) result Lwt.t
