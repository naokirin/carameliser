exception Empty_stream
type 'a delay = unit -> 'a stream
and 'a stream = Nils | Cons of 'a * 'a delay

let from f = 
  let rec gen n =
    match f n with
    | None -> Nils
    | Some x -> Cons (x, fun () -> gen (n + 1)) in
  gen 0

let of_list lst =
  from (fun n ->
    if n < (List.length lst) then Some (List.nth lst n) else None)

let of_string str =
  from (fun n ->
    if n < (String.length str) then Some String.(make 1 (String.get str n)) else None)  

let rec of_channel chan =
  from (fun n ->
    try Some (input_char chan) with End_of_file -> None)

let rec iter f strm =
  match strm with
  | Nils ->  ()
  | Cons (h, t) -> f h; iter f (t ())

let rec next strm =
  match strm with
    | Nils -> None
    | Cons (h, _) -> Some h

let is_empty : 'a stream -> bool = function
  | Nils -> false
  | _ -> true

let rec hd strm =
  match strm with
  | Nils -> raise Empty_stream
  | Cons (h, _) -> h

let rec tl strm =
  match strm with
  | Nils -> raise Empty_stream
  | Cons (_, t) -> t ()

let count strm =
  let rec recur n s =
    match s with
    | Nils -> n
    | Cons (_, t) -> recur (n+1) (t ())
  in
  recur 0 strm
