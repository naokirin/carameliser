type ('a, 'b) either = Left of 'a | Right of 'b

type ('a, 'b) t = ('a, 'b) either

val ret_either: f:('a -> 'b) -> 'a -> (exn, 'b) t

module Either_monad : Caramel_monad.S2 with type ('a, 'b) t := ('a, 'b) t
