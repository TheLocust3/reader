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


let uri_to_yojson uri = uri |> Uri.to_string |> [%to_yojson: string]
let uri_of_yojson json = json |> [%of_yojson: string] |> Result.map(Uri.of_string)
