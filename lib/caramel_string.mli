type t = string

(** These functions in StringLabels *)
val length : t -> int
val get : t -> int -> char
val set : t -> int -> char -> unit
val create : int -> t
val make : int -> char -> t
val copy : t -> t
val sub : string -> pos:int -> len:int -> string
val fill : string -> pos:int -> len:int -> char -> unit
val blit : src:string -> src_pos:int -> dst:string -> dst_pos:int -> len:int -> unit
val concat : sep:string -> string list -> string
val iter : f:(char -> unit) -> string -> unit
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
val unsafe_blit : src:string -> src_pos:int -> dst:string -> dst_pos:int -> len:int -> unit
val unsafe_fill : string -> pos:int -> len:int -> char -> unit


(** [is_empty] returns true if string length is zero. *)
val is_empty : t -> bool

(** [hd] returns first charactor in string. *)
val hd : t -> char

(** [tl] returns string without a first charactor. *)
val tl : t -> t

(** [string_of_char] is char to string. *)
val string_of_char : char -> t
