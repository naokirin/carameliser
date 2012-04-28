type ('a, 'b) either = Left of 'a | Right of 'b

module Either : sig
  val ret_either: ('a -> 'b) -> 'a -> ('c, 'b) either
end
