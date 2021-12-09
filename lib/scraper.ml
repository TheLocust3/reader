open Lwt

module Source = struct
  type source = {
    uri : string;
    links : string list;
  } [@@deriving yojson]

  let create uri = { uri = uri; links = [] }
end

let scrape uri =
  Xml.htmlFromUri uri >|= fun (_) -> Source.create (Uri.to_string uri)
