module StringSet = Set.Make(String)
type setEncoding = string list [@@deriving yojson]
let set_to_yojson set = setEncoding_to_yojson @@ StringSet.elements set
let set_of_yojson json = 
  Result.(match setEncoding_of_yojson json with
            | Ok set -> Ok (StringSet.of_list(set))
            | Error s -> Error s)
type string_set = StringSet.t [@to_yojson set_to_yojson]
                     [@of_yojson set_of_yojson]
                     [@@deriving yojson]

type t = {
  uri : string;
  links : string_set;
} [@@deriving yojson]

let empty uri = { uri = uri; links = StringSet.empty }

let with_link link source = (match (link |> Uri.of_string |> Uri.host) with
  | Some(host) -> { source with links = StringSet.add host source.links }
  | None -> source)