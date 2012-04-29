module Option = struct
  let is_some = function
    |Some _ -> true
    |_ -> false

  let is_none x = not (is_some x)

  let value x ~default =
    match x with
    |(Some n) -> n
    |None -> default

  let ret_option ~f x =
    try
      Some (f x)
    with e ->
      None
end
