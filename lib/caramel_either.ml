type ('a, 'b) either =
  |Left of 'a
  |Right of 'b

module T = struct
  type ('a, 'b) t = ('a, 'b) either
end

include T

let ret_either ~f x =
  try
    Right (f x)
  with e ->
    Left e

(*$T ret_either
  ret_either ~f:(fun n -> if n<0 then invalid_arg "invalid" else n) 1 = Right 1
  ret_either ~f:(fun n -> if n<0 then invalid_arg "invalid" else n) ~-1 = Left (Invalid_argument "invalid")
*)


module EitherMonad = Caramel_monad.Make2(struct
  type ('a, 'b) t = ('a, 'b) either

  let bind m f = match m with
    | Right x -> f x
    | Left x -> Left x

  let return x = Right x
end)
