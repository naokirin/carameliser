type ('a, 'b) either =
  |Left of 'a
  |Right of 'b

module Either = struct
  let ret_either f x =
    try
      Right (f x)
    with e ->
      Left e
end
