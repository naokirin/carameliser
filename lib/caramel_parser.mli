type 'a stream = 'a Caramel_lazy_stream.stream

type ('a, 'b) parser

include Caramel_monad.S2 with type ('a, 'b) t := ('a, 'b) parser

(* Parse stream. *)
val parse : ('a, 'b) parser -> 'a stream -> 'b option

(* Parse stream with any position. *)
val parse_any : ('a, 'b) parser -> 'a stream -> 'b option

(* Parse exactly stream. *)
val parse_exactly : ('a, 'b) parser -> 'a stream -> 'b option

(* Parse stream at the end. *)
val parse_tl : ('a, 'b) parser -> 'a stream -> 'b option

(* Make chosing parser. *)
val choose : ('a, 'b) parser -> ('a, 'b) parser -> ('a, 'b) parser
val ( <|> ) : ('a, 'b) parser -> ('a, 'b) parser -> ('a, 'b) parser

(* Make parser by a function. *)
val token : ('a -> 'b option) -> ('a, 'b) parser

(* Make attempting parser. However, use without many or fold, because don't stop a recursive call. *)
val attempt : ('a, 'b) parser -> ('a, 'b) parser

(* manyf and manyf1 is similar to many and many1. But the function apply to result. *)
val manyf : f:('a -> 'b) -> ('c, 'a) parser -> ('c, 'b list) parser
val manyf1 : f:('a -> 'b) -> ('c, 'a) parser -> ('c, 'b list) parser

(* Make a parser to return list. *)
val many : ('a, 'b) parser -> ('a, 'b list) parser
val many1 : ('a, 'b) parser -> ('a, 'b list) parser

(* Make a Folding parser. *)
val fold : f:('a -> 'b -> 'a) -> init:'a -> ('c, 'b) parser -> ('c, 'a) parser
val fold1 : f:('a -> 'b -> 'a) -> init:'a -> ('c, 'b) parser -> ('c, 'a) parser

(* Make a parser by argument. *)
val is : 'a -> ('a, 'a) parser
val is_not : 'a -> ('a, 'a) parser

(* Make a parser to parsing something. *)
val something : ('a, 'a) parser

(* Make a parser to choise right or left. *)
val ( >>* ) : ('a, 'b) parser -> ('a, 'c) parser -> ('a, 'c) parser
val ( *>> ) : ('a, 'b) parser -> ('a, 'c) parser -> ('a, 'b) parser

(* Similar to ( >>* ) and ( *>> ). *)
val ( +>> ) : ('a, 'b) parser -> ('a, 'c) parser -> ('a, 'b) parser
val ( ->> ) : ('a, 'b) parser -> ('a, 'c) parser -> ('a, 'b) parser
val ( >>+ ) : ('a, 'b) parser -> ('a, 'b) parser -> ('a, 'b) parser
val ( >>- ) : ('a, 'b) parser -> ('a, 'b) parser -> ('a, 'b) parser

val stream_of_list : 'a list Caramel_option.t -> 'a stream

(* To (string, string) parser *)
module String_parser : sig

  val stream_of_string : string -> string stream

  (* Make a parser with connecting result. *)
  val ( &>> ) : (string, string) parser -> (string, string) parser -> (string, string) parser
  val ( $>> ) : (string, string) parser -> (string, string) parser -> (string, string) parser

  val foldstr : (string, string) parser -> (string, string) parser
  val foldstr1 : (string, string) parser -> (string, string) parser

  val something_of : string -> (string -> (string, string) parser) -> (string, string) parser
  val one_of : string -> (string, string) parser
  val none_of : string -> (string, string) parser
  val many_of : string -> (string, string) parser

  val parse_string : string -> (string, string) parser

  val lower : (string, string) parser
  val upper : (string, string) parser
  val letter : (string, string) parser
  val number : (string, string) parser
  val letter_and_num : (string, string) parser
  val space : (string, string) parser
  val newline : (string, string) parser
  val tab : (string, string) parser

  val one_or_more : (string, string) parser -> (string, string) parser

  val lowers : (string, string) parser
  val uppers : (string, string) parser
  val letters : (string, string) parser
  val numbers : (string, string) parser
  val letters_and_nums : (string, string) parser
  val spaces : (string, string) parser
  val newlines : (string, string) parser
  val tabs : (string, string) parser
end
