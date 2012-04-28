(** [try_find] is similar to find, but it does NOT raise Not_found.
    Return to type Option, so it return None if there is no value that satisfies the received function in the list. *)
val try_find: f:('a -> bool) -> 'a list -> 'a option

(** [try_findi] is similar to findi, but it does Not raise Not_found. *)
val try_findi: f:(int -> 'a -> bool) -> 'a list -> (int * 'a) option

(** [try_rfind] is similar to rfind, but it does Not raise Not_found. *)
val try_rfind: f:('a -> bool) -> 'a list -> 'a option

(** [try_reduce] is the same as reduce, but None if there is no element in the l. *)
val try_reduce: f:('a -> 'a -> 'a) -> 'a list -> 'a option
