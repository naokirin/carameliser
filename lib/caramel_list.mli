module List : sig
  include module type of ListLabels

  (** [Invalid_index] which index is invalid *)
  exception Invalid_index of int

  exception Invalid_empty

  (** [split_nth] split nth in the list.
      Riase Invalid_index if the index is out of bounds. *)
  val split_nth: 'a list -> int -> ('a list * 'a list)

  (** [split_while] split while the function returned true. *)
  val split_while: f:('a -> bool) -> 'a list -> ('a list * 'a list)

  (** [is_empty] returns that the list is empty or not. *)
  val is_empty: 'a list -> bool

  (** [iteri] is similar to iter, but it's iterative function receive each element index. *)
  val iteri: f:(int -> 'a -> unit) -> 'a list -> unit

  (** [collect] is the received function apply to each elements, and return to a list to append each result. *)
  val collect: f:('a -> 'b list) -> 'a list -> 'b list

  (** [filter_map] is similar to filter, but return a list appending results from the received function. *)
  val filter_map: f:('a -> 'b option) -> 'a list -> 'b list

  (** [mapi] is similar to map, but it's iterative function receive each element index. *)
  val mapi: f:(int -> 'a -> 'b) -> 'a list -> 'b list

  (** [findi ~f l] is similar to find, but appling with index and return (index, x) *)
  val findi: f:(int -> 'a -> bool) -> 'a list -> (int * 'a)

  (** [rfind] is similar to find, but return mutching the last element. *)
  val rfind: f:('a -> bool) -> 'a list -> 'a

  (** [reduce ~f:f l] is apply the function to the element in l.
      If elements is i0..iN, [reduce] is the same to f ((f i0 i1) i2) ...) iN.    [reduce] raises Invalid_empty if there is no element in l. *)
  val reduce: f:('a -> 'a -> 'a) -> 'a list -> 'a

  (** [unique] returns the list without any duplicate element.
      Default comparator is (=) if no applied ?cmp. *)
  val unique: ?cmp:('a -> 'a -> bool) -> 'a list -> 'a list

  (** [drop] returns the list without the element of index.
      Raise Invalid_index if the index is out of bounds. *)
  val drop: 'a list -> int -> 'a list

  (** [drop_while] returns the list without the element until the function returned false. *)
  val drop_while: f:('a -> bool) -> 'a list -> 'a list

  (** [remove] remove mutched first element in the list. *)
  val remove: ?cmp:('a -> 'a -> bool) -> 'a -> 'a list -> 'a list

  (** [remove_all] remove mutched all element in the list. *)
  val remove_all: ?cmp:('a -> 'a -> bool) -> 'a -> 'a list -> 'a list

  (** [take] takes nth elements in the list.
      Raise Invalid_index if the index is out of bounds. *)
  val take: 'a list -> int -> 'a list

  (** [take_while] returns the list until the function returned true. *)
  val take_while: f:('a -> bool) -> 'a list -> 'a list

  (** [init ~f n] returns the list containing (f 0),(f 1)...,(f (n-1)).
      Raise Invalid_index if the index is out of bounds. *)
  val init: f:(int -> 'a) -> int -> 'a list

  (** [make n a] returns the list containing a and to be length n.
      Raise Invalid_index if the index is out of bounds. *)
  val make: 'a -> int -> 'a list

  (** [sub] makes a sublist. *)
  val sub: 'a list -> pos:int -> len:int -> 'a list

  (** [stop] *)
  val slice: 'a list -> start:int -> stop:int -> 'a list

  (** [of_array] is the same as Array.to_list. *)
  val of_array: 'a array -> 'a list

  (** [to_array] is the same as Array.of_array. *)
  val to_array: 'a list -> 'a array


  (** In Module Optional functions return value of either. *)
  module Optional : sig

    (** [find] is similar to find, but does NOT raise Not_found. *)
    val find: f:('a -> bool) -> 'a list -> 'a option

    (** [findi] is similar to findi, but does NOT raise Not_found. *)
    val findi: f:(int -> 'a -> bool) -> 'a list -> (int * 'a) option

    (** [rfind] is similar to rfind, but does NOT raise Not_found. *)
    val rfind: f:('a -> bool) -> 'a list -> 'a option

    (** [reduce] is the similar to reduce, but None if there is no element in the l. *)
    val reduce: f:('a -> 'a -> 'a) -> 'a list -> 'a option

    (** [assoc] is the similar to assoc, but does NOT raise Not_found. *)
    val assoc: 'a -> ('a * 'b) list -> 'b option

    (** [combine] is the similar to combine, but does NOT raise Invalid_argument *)
    val combine: 'a list -> 'b list -> ('a * 'b) list option

    (** [split_nth] is the similar to combine, but does NOT raise Invalid_index. *)
    val split_nth: 'a list -> int -> ('a list * 'a list) option

    (** [init] is the similar to init, but does NOT raise Invalid_index. *)
    val init: f:(int -> 'a) -> int -> 'a list option

    (** [make] is the similar to make, but does NOT raise Invalid_index  *)
    val make: 'a -> int -> 'a list option

    (** [take] is the similar to take, but does NOT raise Invalid_index. *)
    val take: 'a list -> int -> 'a list option

    (** [drop] is the similar to drop, but does NOT raise Invalid_index. *)
    val drop: 'a list -> int -> 'a list option

    (** [hd] is the similar to hd, but does NOT raise Failure. *)
    val hd: 'a list -> 'a option

    (** [tl] is the similar to tl, but does NOT raise Failure. *)
    val tl: 'a list -> 'a list option

    (** [nth] is the similar to nth, but does NOT raise Invalid_argument. *)
    val nth: 'a list -> int -> 'a option

    (** [sub] makes a sublist. *)
    val sub: 'a list -> pos:int -> len:int -> 'a list option

    (** [slice] makes a sublist. *)
    val slice: 'a list -> start:int -> stop:int -> 'a list option
  end


  (** In Module Exceptionless functions return value of either. *)
  module Exceptionless : sig
    open Caramel_either

    (** [try_find] is similar to find, but does NOT raise Not_found. *)
    val try_find: f:('a -> bool) -> 'a list -> (exn, 'a) either

    (** [try_findi] is similar to findi, but does NOT raise Not_found. *)
    val try_findi: f:(int -> 'a -> bool) -> 'a list -> (exn, (int * 'a)) either

    (** [try_rfind] is similar to rfind, but does NOT raise Not_found. *)
    val try_rfind: f:('a -> bool) -> 'a list -> (exn, 'a) either

    (** [try_reduce] is the similar to reduce, but None if there is no element in the l. *)
    val try_reduce: f:('a -> 'a -> 'a) -> 'a list -> (exn, 'a) either

    (** [try_assoc] is the similar to assoc, but does NOT raise Not_found. *)
    val try_assoc: 'a -> ('a * 'b) list -> (exn, 'b) either

    (** [try_combine] is the similar to combine, but does NOT raise Invalid_argument *)
    val try_combine: 'a list -> 'b list -> (exn, ('a * 'b) list) either

    (** [try_split_nth] is the similar to combine, but does NOT raise Invalid_index. *)
    val try_split_nth: 'a list -> int -> (exn, ('a list * 'a list)) either

    (** [try_init] is the similar to init, but does NOT raise Invalid_index. *)
    val try_init: f:(int -> 'a) -> int -> (exn, 'a list) either

    (** [try_make] is the similar to make, but does NOT raise Invalid_index  *)
    val try_make: 'a -> int -> (exn, 'a list) either

    (** [try_take] is the similar to take, but does NOT raise Invalid_index. *)
    val try_take: 'a list -> int -> (exn, 'a list) either

    (** [try_drop] is the similar to drop, but does NOT raise Invalid_index. *)
    val try_drop: 'a list -> int -> (exn, 'a list) either

    (** [try_hd] is the similar to hd, but does NOT raise Failure. *)
    val try_hd: 'a list -> (exn, 'a) either

    (** [try_tl] is the similar to tl, but does NOT raise Failure. *)
    val try_tl: 'a list -> (exn, 'a list) either

    (** [try_nth] is the similar to nth, but does NOT raise Invalid_argument. *)
    val try_nth: 'a list -> int -> (exn, 'a) either

    (** [try_sub] makes a sublist. *)
    val try_sub: 'a list -> pos:int -> len:int -> (exn, 'a list) either

    (** [try_slice] makes a sublist. *)
    val try_slice: 'a list -> start:int -> stop:int -> (exn, 'a list) either
  end

end
