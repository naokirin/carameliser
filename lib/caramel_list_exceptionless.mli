module Exceptionless : sig
  open Caramel_either

  (** [try_find] is similar to find, but does NOT raise Not_found.
      Return to type Option, so it return None if there is no value that satisfies the received function in the list. *)
  val try_find: f:('a -> bool) -> 'a list -> 'a option

  (** [try_findi] is similar to findi, but does NOT raise Not_found. *)
  val try_findi: f:(int -> 'a -> bool) -> 'a list -> (int * 'a) option

  (** [try_rfind] is similar to rfind, but does NOT raise Not_found. *)
  val try_rfind: f:('a -> bool) -> 'a list -> 'a option

  (** [try_reduce] is the similar to reduce, but None if there is no element in the l. *)
  val try_reduce: f:('a -> 'a -> 'a) -> 'a list -> 'a option

  (** [try_assoc] is the similar to assoc, but does NOT raise Not_found. *)
  val try_assoc: 'a -> ('a * 'b) list -> (exn, 'b) either

  (** [try_combine] is the similar to combine, but does NOT raise Invalid_argument *)
  val try_combine: 'a list -> 'b list -> (exn, ('a * 'b) list) either

  (** [try_split_nth] is the similar to combine, but does NOT raise Invalid_index. *)
  val try_split_nth: int -> 'a list -> (exn, ('a list * 'a list)) either
end
