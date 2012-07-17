
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
  type ('a, 'b) state = 'a -> ('b * 'a)
  include Caramel_monad.S2 with type ('a, 'b) t := ('a, 'b) state

  val ( =<< ) : ('a -> ('c, 'b) state) -> ('c, 'a) state -> ('c, 'b) state
  val ( >>> ) : ('c, 'a) state -> ('c, 'b) state -> ('c, 'b) state
  val get : ('a, 'a) state
  val put : 'a -> ('a, unit) state

end



















