include module type of ArrayLabels

type 'a t = 'a array

(** [add_last] add the value at the last. *)
val add_last : 'a -> 'a t -> 'a t

(** [add_first] add the value at the first. *)
val add_first : 'a -> 'a t -> 'a t

(** [hd] returns the element of index 0 in array *)
val hd : 'a t -> 'a

(** [tl] returns an array including the element of index 1..len-1 in receiving array. *)
val tl : 'a t -> 'a t

(** [filter] removes the elements if ~f returns false. *)
val filter : f:('a -> bool) -> 'a t -> 'a t

(** [filter_map] removes the elements if ~f returns None. *)
val filter_map : f:('a -> 'b option) -> 'a t -> 'b t

(** [reduce] returns (f ..(f (f a1 a2) a3)..).  *)
val reduce : f:('a -> 'a -> 'a) -> 'a t -> 'a

(** [combine] returns [|(a1, b1), (a2, b2), ..|]. *)
val combine : 'a t -> 'b t -> ('a * 'b) t

(** [replace] returns the array that arr.(i) <- f (arr.(i)). *)
val replace : f:('a -> 'a) -> 'a t -> int -> 'a t

(** [split] transform [|(a1, b1); (a2, b2); ..|] to ([|a1; a2; ..|], [|b1; b2; ..|]). *)
val split : ('a * 'b) t -> ('a t * 'b t)

(** [is_empty] is true if the array is empty. *)
val is_empty : 'a t -> bool

(** [collect] returns (f a1) @ (f a2) @ .. @ (f an). *)
val collect : f:('a -> 'b t) -> 'a t -> 'b t

(** [exists] returns true if the array exists the function return true. *)
val exists : f:('a -> bool) -> 'a t -> bool

(** [for_all] is true, for all elements in the array if the function return true.  *)
val for_all : f:('a -> bool) -> 'a t -> bool

(** [find] returns the first element that the function returns true. *)
val find : f:('a -> bool) -> 'a t -> 'a

(** [findi] returns the index and the first element that the function returns true. *)
val findi : f:(int -> 'a -> bool) -> 'a t -> (int * 'a)

(** [find_all] returns the array including all elements that the function returns true. *)
val find_all : f:('a -> bool) -> 'a t -> 'a t
