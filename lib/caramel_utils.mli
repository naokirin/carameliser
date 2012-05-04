
(** [(|>)] is forward pipe operator. *)
val (|>): 'a -> ('a -> 'b) -> 'b

(** [(|>)] is backward pipe operator. *)
val (<|): ('a -> 'b) -> 'a -> 'b

(** [(>>)] is forward composition operator. *)
val (>>): ('a -> 'b) -> ('b -> 'd) -> 'a -> 'd

(** [(<<)] is backward composition operator. *)
val (<<): ('a -> 'b) -> ('d -> 'a) -> 'd -> 'b
