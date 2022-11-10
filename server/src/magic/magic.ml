module Let = struct
  let (let*) x f = Option.bind x f
  let (let**) x f = Result.bind x f
end

module Lwt = MagicLwt
module List = MagicList
module Option = MagicOption
