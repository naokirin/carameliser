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

  module MaybeMonad = Caramel_monad.Monad.Make(struct
    type 'a t = 'a option

    let bind x f = match x with
      | Some x -> f x
      | None -> None

    let return x = Some x
  end)
end
