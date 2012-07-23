type t = string

(** These functions in StringLabels *)
val length : t -> int
val get : t -> int -> char
val set : t -> int -> char -> unit
val create : int -> t
val make : int -> char -> t
val copy : t -> t
val sub : t -> pos:int -> len:int -> t
val fill : t -> pos:int -> len:int -> char -> unit
val blit : src:t -> src_pos:int -> dst:t -> dst_pos:int -> len:int -> unit
val concat : sep:t -> t list -> t
val iter : f:(char -> unit) -> t -> unit
val escaped : t -> t
val index : t -> char -> int
val rindex : t -> char -> int
val index_from : t -> int -> char -> int
val rindex_from : t -> int -> char -> int
val contains : t -> char -> bool
val contains_from : t -> int -> char -> bool
val rcontains_from : t -> int -> char -> bool
val uppercase : t -> t
val lowercase : t -> t
val capitalize : t -> t
val uncapitalize : t -> t
val compare : t -> t -> int
val unsafe_get : t -> int -> char
val unsafe_set : t -> int -> char -> unit
val unsafe_blit : src:t -> src_pos:int -> dst:t -> dst_pos:int -> len:int -> unit
val unsafe_fill : t -> pos:int -> len:int -> char -> unit


(** [is_empty] returns true if string length is zero. *)
val is_empty : t -> bool

(** [hd] returns first charactor in string. *)
val hd : t -> char

(** [tl] returns string without a first charactor. *)
val tl : t -> t

(** [string_of_char] is char to string. *)
val string_of_char : char -> t

(** [explode] is string to char list *)
val explode : t -> char list

(** [collect] is char list to string *)
val collect : char list -> t

(** In Module Optional functions return value of option. *)
module Optional : sig
  val get : t -> int -> char option
  val create : int -> t option
  val make : int -> char -> t option
  val sub : t -> pos:int -> len:int -> t option
  val index : t -> char -> int option
  val rindex : t -> char -> int option
  val index_from : t -> int -> char -> int option
  val rindex_from : t -> int -> char -> int option
  val contains_from : t -> int -> char -> bool option
  val rcontains_from : t -> int -> char -> bool option
end


(** In Module Of_Caramel_either.either functions return value of Caramel_either.either. *)
module Of_either : sig
  val get : t -> int -> (exn, char) Caramel_either.either 
  val create : int -> (exn, t) Caramel_either.either
  val make : int -> char -> (exn, t) Caramel_either.either
  val sub : t -> pos:int -> len:int -> (exn, t) Caramel_either.either
  val index : t -> char -> (exn, int) Caramel_either.either
  val rindex : t -> char -> (exn, int) Caramel_either.either
  val index_from : t -> int -> char -> (exn, int) Caramel_either.either
  val rindex_from : t -> int -> char -> (exn, int) Caramel_either.either
  val contains_from : t -> int -> char -> (exn, bool) Caramel_either.either
  val rcontains_from : t -> int -> char -> (exn, bool) Caramel_either.either
end
