let is_some = function
  |Some _ -> true
  |_ -> false

(*$T is_some
  is_some (Some 1)
  not (is_some None)
*)


let is_none x = not (is_some x)

(*$T is_none
  is_none None
  not (is_none (Some 1))
*)


let value x ~default =
  match x with
  |(Some n) -> n
  |None -> default

(*$T value
  value (Some 1) ~default:0 = 1
  value None ~default:0 = 0
*)


let ret_option ~f x =
  try
    Some (f x)
  with e ->
    None

(*$T ret_option
  ret_option ~f:(fun n -> if n<0 then invalid_arg "invalid" else n) 1 = (Some 1)
  ret_option ~f:(fun n -> if n<0 then invalid_arg "invalid" else n) ~-1 = None
*)


module MaybeMonad = Caramel_monad.Make(struct
  type 'a t = 'a option

  let bind x f = match x with
    | Some x -> f x
    | None -> None

  let return x = Some x
end)
