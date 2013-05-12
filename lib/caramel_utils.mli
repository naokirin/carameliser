
(** [(|>)] is forward pipe operator. *)
val (|>): 'a -> ('a -> 'b) -> 'b

(** [(|>)] is backward pipe operator. *)
val (<|): ('a -> 'b) -> 'a -> 'b

(** [(>>)] is forward composition operator. *)
val (>>): ('a -> 'b) -> ('b -> 'd) -> 'a -> 'd

(** [(<<)] is backward composition operator. *)
val (<<): ('a -> 'b) -> ('d -> 'a) -> 'd -> 'b

(** State monad *)
module State_monad : sig
  type ('a, 'b) state
  include Caramel_monad.S2 with type ('a, 'b) t := ('a, 'b) state

  val ( =<< ) : ('a -> ('c, 'b) state) -> ('c, 'a) state -> ('c, 'b) state
  val ( >>> ) : ('c, 'a) state -> ('c, 'b) state -> ('c, 'b) state
  val get : ('a, 'a) state
  val put : 'a -> ('a, unit) state
  val run : ('a, 'b) state -> 'a -> ('b * 'a)
end

(** Continuation monad *)
module Continuation_monad : sig
  type ('a, 'b) cont
  include Caramel_monad.S2 with type ('a, 'b) t := ('a, 'b) cont

  val run : ('a, 'a) cont -> 'a

  val reset : ('a, 'a) cont -> ('b, 'a) cont
  val shift : (('b -> ('a, 'a) cont) -> ('a, 'a) cont) -> ('a, 'b) cont
  val callcc : (('a -> ('c, 'b) cont) -> ('c, 'a) cont) ->
  ('c, 'a) cont
end

