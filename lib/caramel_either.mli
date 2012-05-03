type ('a, 'b) either = Left of 'a | Right of 'b

val ret_either: f:('a -> 'b) -> 'a -> (exn, 'b) either

module EitherMonad : Caramel_monad.S2 with type ('a, 'b) t := ('a, 'b) either
