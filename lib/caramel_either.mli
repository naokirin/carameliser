type ('a, 'b) either = Left of 'a | Right of 'b

module Either : sig
  val ret_either: f:('a -> 'b) -> 'a -> (exn, 'b) either
end
