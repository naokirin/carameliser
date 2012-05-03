type ('a, 'b) either =
  |Left of 'a
  |Right of 'b

module Either = struct
  let ret_either ~f x =
    try
      Right (f x)
    with e ->
      Left e

  module EitherMonad = Caramel_monad.Monad.Make2(struct
    type ('a, 'b) t = ('a, 'b) either

    let bind m f = match m with
      | Right x -> f x
      | Left x -> Left x

    let return x = Right x
  end)
end
