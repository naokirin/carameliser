include module type of ListLabels

type 'a t = 'a list

(** [Invalid_index] which index is invalid *)
exception Invalid_index of int

exception Invalid_empty

(** [split_nth] split nth in the list.
    Riase Invalid_index if the index is out of bounds. *)
val split_nth: 'a t -> int -> ('a t * 'a t)

(** [split_while] split while the function returned true. *)
val split_while: f:('a -> bool) -> 'a t -> ('a t * 'a t)

(** [is_empty] returns that the list is empty or not. *)
val is_empty: 'a t -> bool

(** [iteri] is similar to iter, but it's iterative function receive each element index. *)
val iteri: f:(int -> 'a -> unit) -> 'a t -> unit

(** [collect] is the received function apply to each elements, and return to a t to append each result. *)
val collect: f:('a -> 'b t) -> 'a t -> 'b t

(** [filter_map] is similar to filter, but return a t appending results from the received function. *)
val filter_map: f:('a -> 'b option) -> 'a t -> 'b t

(** [mapi] is similar to map, but it's iterative function receive each element index. *)
val mapi: f:(int -> 'a -> 'b) -> 'a t -> 'b t

(** [findi ~f l] is similar to find, but appling with index and return (index, x) *)
val findi: f:(int -> 'a -> bool) -> 'a t -> (int * 'a)

(** [rfind] is similar to find, but return mutching the last element. *)
val rfind: f:('a -> bool) -> 'a t -> 'a

(** [reduce ~f:f l] is apply the function to the element in l.
    If elements is i0..iN, [reduce] is the same to f ((f i0 i1) i2) ...) iN.    [reduce] raises Invalid_empty if there is no element in l. *)
val reduce: f:('a -> 'a -> 'a) -> 'a t -> 'a

(** [unique] returns the list without any duplicate element.
    Default comparator is (=) if no applied ?cmp. *)
val unique: ?cmp:('a -> 'a -> bool) -> 'a t -> 'a t

(** [drop] returns the list without the element of index.
    Raise Invalid_index if the index is out of bounds. *)
val drop: 'a t -> int -> 'a t

(** [drop_while] returns the list without the element until the function returned false. *)
val drop_while: f:('a -> bool) -> 'a t -> 'a t

(** [remove] remove mutched first element in the list. *)
val remove: ?cmp:('a -> 'a -> bool) -> 'a -> 'a t -> 'a t

(** [remove_all] remove mutched all element in the list. *)
val remove_all: ?cmp:('a -> 'a -> bool) -> 'a -> 'a t -> 'a t

(** [take] takes nth elements in the list.
    Raise Invalid_index if the index is out of bounds. *)
val take: 'a t -> int -> 'a t

(** [take_while] returns the list until the function returned true. *)
val take_while: f:('a -> bool) -> 'a t -> 'a t

(** [init ~f n] returns the list containing (f 0),(f 1)...,(f (n-1)).
    Raise Invalid_index if the index is out of bounds. *)
val init: f:(int -> 'a) -> int -> 'a t

(** [make n a] returns the list containing a and to be length n.
    Raise Invalid_index if the index is out of bounds. *)
val make: 'a -> int -> 'a t

(** [sub] makes a sublist. *)
val sub: 'a t -> pos:int -> len:int -> 'a t

(** [stop] *)
val slice: 'a t -> start:int -> stop:int -> 'a t

(** [of_array] is the same as Array.to_list. *)
val of_array: 'a array -> 'a t

(** [to_array] is the same as Array.of_array. *)
val to_array: 'a t -> 'a array

val (@): 'a t -> 'a t -> 'a t

module Infix : sig
  (** [(@)] is the same as append. *)
  val (@): 'a t -> 'a t -> 'a t
end


(** In Module Optional functions return value of option. *)
module Optional : sig

  (** [find] is similar to find, but does NOT raise Not_found. *)
  val find: f:('a -> bool) -> 'a t -> 'a option

  (** [findi] is similar to findi, but does NOT raise Not_found. *)
  val findi: f:(int -> 'a -> bool) -> 'a t -> (int * 'a) option

  (** [rfind] is similar to rfind, but does NOT raise Not_found. *)
  val rfind: f:('a -> bool) -> 'a t -> 'a option

  (** [reduce] is the similar to reduce, but None if there is no element in the l. *)
  val reduce: f:('a -> 'a -> 'a) -> 'a t -> 'a option

  (** [assoc] is the similar to assoc, but does NOT raise Not_found. *)
  val assoc: 'a -> ('a * 'b) t -> 'b option

  (** [combine] is the similar to combine, but does NOT raise Invalid_argument *)
  val combine: 'a t -> 'b t -> ('a * 'b) t option

  (** [split_nth] is the similar to combine, but does NOT raise Invalid_index. *)
  val split_nth: 'a t -> int -> ('a t * 'a t) option

  (** [init] is the similar to init, but does NOT raise Invalid_index. *)
  val init: f:(int -> 'a) -> int -> 'a t option

  (** [make] is the similar to make, but does NOT raise Invalid_index  *)
  val make: 'a -> int -> 'a t option

  (** [take] is the similar to take, but does NOT raise Invalid_index. *)
  val take: 'a t -> int -> 'a t option

  (** [drop] is the similar to drop, but does NOT raise Invalid_index. *)
  val drop: 'a t -> int -> 'a t option

  (** [hd] is the similar to hd, but does NOT raise Failure. *)
  val hd: 'a t -> 'a option

  (** [tl] is the similar to tl, but does NOT raise Failure. *)
  val tl: 'a t -> 'a t option

  (** [nth] is the similar to nth, but does NOT raise Invalid_argument. *)
  val nth: 'a t -> int -> 'a option

  (** [sub] makes a sublist. *)
  val sub: 'a t -> pos:int -> len:int -> 'a t option

  (** [slice] makes a sublist. *)
  val slice: 'a t -> start:int -> stop:int -> 'a t option
end


(** In Module Of_Caramel_either.either functions return value of Caramel_either.either. *)
module Of_either : sig

  (** [find] is similar to find, but does NOT raise Not_found. *)
  val find: f:('a -> bool) -> 'a t -> (exn, 'a) Caramel_either.either

  (** [findi] is similar to findi, but does NOT raise Not_found. *)
  val findi: f:(int -> 'a -> bool) -> 'a t -> (exn, (int * 'a)) Caramel_either.either

  (** [rfind] is similar to rfind, but does NOT raise Not_found. *)
  val rfind: f:('a -> bool) -> 'a t -> (exn, 'a) Caramel_either.either

  (** [reduce] is the similar to reduce, but None if there is no element in the l. *)
  val reduce: f:('a -> 'a -> 'a) -> 'a t -> (exn, 'a) Caramel_either.either

  (** [assoc] is the similar to assoc, but does NOT raise Not_found. *)
  val assoc: 'a -> ('a * 'b) t -> (exn, 'b) Caramel_either.either

  (** [combine] is the similar to combine, but does NOT raise Invalid_argument *)
  val combine: 'a t -> 'b t -> (exn, ('a * 'b) t) Caramel_either.either

  (** [split_nth] is the similar to combine, but does NOT raise Invalid_index. *)
  val split_nth: 'a t -> int -> (exn, ('a t * 'a t)) Caramel_either.either

  (** [init] is the similar to init, but does NOT raise Invalid_index. *)
  val init: f:(int -> 'a) -> int -> (exn, 'a t) Caramel_either.either

  (** [make] is the similar to make, but does NOT raise Invalid_index  *)
  val make: 'a -> int -> (exn, 'a t) Caramel_either.either

  (** [take] is the similar to take, but does NOT raise Invalid_index. *)
  val take: 'a t -> int -> (exn, 'a t) Caramel_either.either

  (** [drop] is the similar to drop, but does NOT raise Invalid_index. *)
  val drop: 'a t -> int -> (exn, 'a t) Caramel_either.either

  (** [hd] is the similar to hd, but does NOT raise Failure. *)
  val hd: 'a t -> (exn, 'a) Caramel_either.either

  (** [tl] is the similar to tl, but does NOT raise Failure. *)
  val tl: 'a t -> (exn, 'a t) Caramel_either.either

  (** [nth] is the similar to nth, but does NOT raise Invalid_argument. *)
  val nth: 'a t -> int -> (exn, 'a) Caramel_either.either

  (** [sub] makes a sublist. *)
  val sub: 'a t -> pos:int -> len:int -> (exn, 'a t) Caramel_either.either

  (** [slice] makes a sublist. *)
  val slice: 'a t -> start:int -> stop:int -> (exn, 'a t) Caramel_either.either
end

module ListMonad : Caramel_monad.S with type 'a t := 'a t
