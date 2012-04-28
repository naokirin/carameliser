
include module type of ListLabels

module Exceptionless : sig
  include module type of Caramel_list_exceptionless
end

(** [Invalid_index] which index is invalid *)
exception Invalid_index of int

(** [split_nth] split nth in the list.
    Riase Invalid_index if the index is out of bounds. *)
val split_nth: int -> 'a list -> ('a list * 'a list)

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
    If elements is i0..iN, [reduce] is the same to f ((f i0 i1) i2) ...) iN.    [reduce] raises Invalid_argument if there is no element in l. *)
val reduce: f:('a -> 'a -> 'a) -> 'a list -> 'a

(** [unique] returns the list without any duplicate element.
    Default comparator is (=) if no applied ?cmp. *)
val unique: ?cmp:('a -> 'a -> bool) -> 'a list -> 'a list

(** [drop] returns the list without the element of index.
    Raise Invalid_index if the index is out of bounds. *)
val drop: int -> 'a list -> 'a list

(** [drop_while] returns the list without the element until the function returned false. *)
val drop_while: f:('a -> bool) -> 'a list -> 'a list

(** [remove] remove mutched first element in the list. *)
val remove: ?cmp:('a -> 'a -> bool) -> 'a -> 'a list -> 'a list

(** [remove_all] remove mutched all element in the list. *)
val remove_all: ?cmp:('a -> 'a -> bool) -> 'a -> 'a list -> 'a list

(** [take] takes nth elements in the list.
    Raise Invalid_index if the index is out of bounds. *)
val take: int -> 'a list -> 'a list

(** [take_while] returns the list until the function returned true. *)
val take_while: f:('a -> bool) -> 'a list -> 'a list

(** [init ~f n] returns the list containing (f 0),(f 1)...,(f (n-1)).
    Raise Invalid_index if the index is out of bounds. *)
val init: f:(int -> 'a) -> int -> 'a list

(** [make n a] returns the list containing a and to be length n.
    Raise Invalid_index if the index is out of bounds. *)
val make: int -> 'a -> 'a list

(** [of_array] is the same as Array.to_list. *)
val of_array: 'a array -> 'a list

(** [to_array] is the same as Array.of_array. *)
val to_array: 'a list -> 'a array
