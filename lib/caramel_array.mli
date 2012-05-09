type 'a t = 'a array

(** the functions in ArrayLabels. *)
val length : 'a t -> int
val get : 'a t -> int -> 'a
val set : 'a t -> int -> 'a -> unit
val make : int -> 'a -> 'a t
val create : int -> 'a -> 'a t
val init : int -> f:(int -> 'a) -> 'a t
val make_matrix : dimx:int -> dimy:int -> 'a -> 'a t t
val create_matrix : dimx:int -> dimy:int -> 'a -> 'a t t
val append : 'a t -> 'a t -> 'a t
val concat : 'a t list -> 'a t
val sub : 'a t -> pos:int -> len:int -> 'a t
val copy : 'a t -> 'a t
val fill : 'a t -> pos:int -> len:int -> 'a -> unit
val blit : src:'a t -> src_pos:int -> dst:'a t -> dst_pos:int -> len:int -> unit
val to_list : 'a t -> 'a list
val of_list : 'a list -> 'a t
val iter : f:('a -> unit) -> 'a t -> unit
val map : f:('a -> 'b) -> 'a t -> 'b t
val iteri : f:(int -> 'a -> unit) -> 'a t -> unit
val mapi : f:(int -> 'a -> 'b) -> 'a t -> 'b t
val fold_left : f:('a -> 'b -> 'a) -> init:'a -> 'b t -> 'a
val fold_right : f:('b -> 'a -> 'a) -> 'b t -> init:'a -> 'a
val sort : cmp:('a -> 'a -> int) -> 'a t -> unit
val stable_sort : cmp:('a -> 'a -> int) -> 'a t -> unit
val fast_sort : cmp:('a -> 'a -> int) -> 'a t -> unit
val unsafe_get : 'a t -> int -> 'a
val unsafe_set : 'a t -> int -> 'a -> unit



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


(** In Module Optional functions return value of option. *)
module Optional : sig
  val reduce : f:('a -> 'a -> 'a) -> 'a t -> 'a option
  val combine :  'a t -> 'b t -> ('a * 'b) t option
  val find : f:('a -> bool) -> 'a t -> 'a option
  val findi : f:(int -> 'a -> bool) -> 'a t -> (int * 'a) option
  val find_all : f:('a -> bool) -> 'a t -> 'a t option
  val get : 'a array -> int -> 'a option
  val make : int -> 'a -> 'a array option
  val init : int -> f:(int -> 'a) -> 'a array option
  val make_matrix : dimx:int -> dimy:int -> 'a -> 'a array array option
  val sub : 'a array -> pos:int -> len:int -> 'a array option
end


(** In Module Of_Caramel_either.either functions return value of Caramel_either.either. *)
module Of_either : sig
  val reduce : f:('a -> 'a -> 'a) -> 'a t -> (exn, 'a) Caramel_either.either
  val combine :  'a t -> 'b t -> (exn, ('a * 'b) t) Caramel_either.either
  val find : f:('a -> bool) -> 'a t -> (exn, 'a) Caramel_either.either
  val findi : f:(int -> 'a -> bool) -> 'a t -> (exn, (int * 'a)) Caramel_either.either
  val find_all : f:('a -> bool) -> 'a t -> (exn, 'a t) Caramel_either.either
  val get : 'a array -> int -> (exn, 'a) Caramel_either.either
  val make : int -> 'a -> (exn, 'a array) Caramel_either.either
  val init : int -> f:(int -> 'a) -> (exn, 'a array) Caramel_either.either
  val make_matrix : dimx:int -> dimy:int -> 'a -> (exn, 'a array array) Caramel_either.either
  val sub : 'a array -> pos:int -> len:int -> (exn, 'a array) Caramel_either.either
end

