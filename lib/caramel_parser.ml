(* This code is based on "https://github.com/toyvo/ocaml-parsec". *)

type 'a stream = 'a Caramel_lazy_stream.stream

type ('a, 'b) result =
  | Fail
  | Match of 'b
  | Parse of ('a, 'b) parser * 'a stream
and ('a, 'b) parser = 'a stream -> ('a, 'b) result

include Caramel_monad.Make2(struct
  type ('a, 'b) t = ('a, 'b) parser

  let rec bind p f strm =
    match p strm with
    | Fail -> Fail
    | Match x -> f x strm
    | Parse (p', s) -> Parse (bind p' f, s)

  let return x _ = Match x
end)

let rec parse p strm =
  match p strm with
  | Fail -> None
  | Match x -> Some x
  | Parse (p', s) -> parse p' s

let choose p p' strm =
  match p strm with
  | Fail -> p' strm
  | x -> x

let ( <|> ) = choose

let token f strm =
  match Caramel_lazy_stream.next strm with
  | None -> Fail
  | Some x ->
    match f x with
    | None -> Fail
    | Some y -> Parse (return y, Caramel_lazy_stream.tl strm)

let rec attempt p strm =
  match p strm with
  | Parse (p', s) -> attempt p' s
  | x -> x

let rec manyf ~f p = manyf1 ~f:f p <|> return []
and manyf1 ~f p = p >>= fun x -> manyf ~f:f p >>= fun xs -> return ((f x)::xs)

let many p = manyf ~f:(fun x -> x) p
and many1 p = manyf1 ~f:(fun x-> x) p

let rec fold ~f ~init p = fold1 ~f:f ~init:init p <|> return init
and fold1 ~f ~init p = p >>= fun x -> fold ~f:f ~init:(f init x) p

let is c = token (fun x -> if x = c then Some x else None)
let is_not c = token (fun x -> if x <> c then Some x else None)

let something c = token (fun x -> Some x) c

let ( >>* ) p p' = p >>= fun _ -> p'
let ( *>> ) p p' s =
  let x = (p >>* p') s in
  if x <> Fail then p s else Fail

let ( +>> ) p p' = p >>= fun x -> fold1 ~f:(fun y z -> y) ~init:x p'
let ( ->> ) p p' = p >>= fun x -> fold  ~f:(fun y z -> y) ~init:x p'
let ( >>+ ) p p' = p >>= fun x -> fold1 ~f:(fun y z -> z) ~init:x p'
let ( >>- ) p p' = p >>= fun x -> fold ~f:(fun y z -> z) ~init:x p'

let stream_of_list lst = Caramel_lazy_stream.of_list (Caramel_option.value ~default:[] lst)

module String_parser = struct

  let stream_of_string s = Caramel_lazy_stream.of_string s

  let ( &>> ) p p' = p >>= fun x -> fold1 ~f:(fun y z -> y^z) ~init:((fun y z -> y^z) "" x) p'
  let ( $>> ) p p' = p >>= fun x -> fold ~f:(fun y z -> y^z) ~init:((fun y z -> y^z) "" x) p'

  let foldstr p = fold ~f:(fun x y -> x^y) ~init:"" p
  let foldstr1 p = fold1 ~f:(fun x y -> x^y) ~init:"" p

  let something_of s f =
    let lst = Caramel_list.collect (Caramel_string.explode s) ~f:(fun c -> [Caramel_string.string_of_char c]) in
    let lst' = Caramel_list.collect lst ~f:(fun x -> [f x]) in
    Caramel_list.(fold_left (tl lst') ~init:(hd lst') ~f:(fun x x' -> x <|> x'))

  let one_of s = something_of s is
  let none_of s = something_of s is_not
  let many_of s = (fold1 ~f:(fun x y -> x^y) ~init:"" (one_of s))

  let parse_string s =
    let lst = Caramel_list.collect (Caramel_string.explode s) ~f:(fun c -> [is (Caramel_string.string_of_char c)]) in
    Caramel_list.(fold_left (tl lst) ~f:(fun x y -> x &>> y) ~init:(hd lst))

  let lower = one_of "abcdefghijklmnopqrstuvwxyz"
  let upper = one_of "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  let letter = lower <|> upper
  let number = one_of "1234567890"
  let letter_and_num = letter <|> number
  let space = is " "
  let newline = is "\n"
  let tab = is "\t"

  let one_or_more p = fold1 ~f:(fun x y -> x^y) ~init:"" p

  let lowers = one_or_more lower
  let uppers = one_or_more upper
  let letters = one_or_more letter
  let numbers = one_or_more number
  let letters_and_nums = one_or_more letter_and_num
  let spaces = one_or_more space
  let newlines = one_or_more newline
  let tabs = one_or_more tab
end
