type ('a, 'b) either = Left of 'a | Right of 'b

module Either : sig
  val ret_either: f:('a -> 'b) -> 'a -> (exn, 'b) either

  module EitherMonad : Caramel_monad.Monad.S2 with type ('a, 'b) t := ('a, 'b) either
end
