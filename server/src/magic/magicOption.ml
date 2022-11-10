let or_else orelse opt =
  match opt with
    | Some some -> Some some
    | None -> orelse ()