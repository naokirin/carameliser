type t = string

include module type of StringLabels with type t := t

val is_empty : t -> bool

val hd : t -> char

val tl : t -> t

val string_of_char : char -> t
