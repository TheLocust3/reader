module Lwt = MagicLwt
module List = MagicList

let (let*) x f = Option.bind x f
let (let**) x f = Result.bind x f
