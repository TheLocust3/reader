module Item = struct
  type t = {
    title : string;
    link : string;
    description : string;
  } [@@deriving yojson]

  let empty = { title = ""; link = ""; description = ""; }
end

type t = {
  title : string;
  link : string;
  description : string;
  items : Item.t list;
} [@@deriving yojson]

let empty = { title = ""; link = ""; description = ""; items = []; }
