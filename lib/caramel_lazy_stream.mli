exception Empty_stream

type 'a stream

val from : (int -> 'a option) -> 'a stream

val of_list : 'a list -> 'a stream

val of_string : string -> string stream

val of_channel : in_channel -> char stream

val iter : ('a -> 'b) -> 'a stream -> unit

val next : 'a stream -> 'a option

val is_empty : 'a stream -> bool

val hd : 'a stream -> 'a

val tl : 'a stream -> 'a stream

val count : 'a stream -> int
