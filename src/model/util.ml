let (let*) x f = Option.bind x f

let strict_flatten l = List.fold_left
  (fun acc item ->
    match item with
      | Some item -> Option.map(fun l -> item :: l)(acc)
      | None -> None)
  (Some [])
  (l)
