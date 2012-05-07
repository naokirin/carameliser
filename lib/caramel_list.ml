include ListLabels

module T = struct
  type 'a t = 'a list
end

include T

exception Invalid_index of int
exception Invalid_empty

let is_empty = function
  |[] -> true
  |_ -> false

(*$T is_empty
  is_empty [] = true
  is_empty [1] = false
*)


let split_nth l n =
  let rec recur i ls = function
    |[] -> ((rev ls), [])
    |x::xs -> if (n <= i) then ((rev ls), x::xs) else recur (i+1) (x::ls) xs
  in
  if n < 0 || n > (length l) then raise (Invalid_index n)
  else recur 0 [] l

(*$T split_nth
  split_nth [1; 2] 1 = ([1], [2])
*)


let split_while ~f l =
  let rec recur ls = function
    |[] -> ((rev ls), [])
    |x::xs -> if f x then recur (x::ls) xs else ((rev ls), x::xs)
  in
  recur [] l

(*$T split_while
  split_while ~f:(fun i -> i<3) [1; 2; 3] = ([1; 2], [3])
*)


let iteri ~f l = ignore (fold_left ~f:(fun i x -> f i x; i+1) ~init:0 l)


let collect ~f l =
  let rec recur ls = function
    |[] -> ls
    |x::xs -> recur (append ls (f x)) xs
  in
  recur [] l

(*$T collect
  collect ~f:(fun i -> [i+1]) [1;2] =[2;3]
*)


let rev_filter_map ~f l =
  let rec recur t ls =
    match t with
    |[] -> ls
    |x::xs ->
      match f x with
      |Some n -> recur xs (n::ls)
      |None -> recur xs ls
  in
  recur l []


let filter_map ~f l = rev (rev_filter_map ~f:f l)

(*$T filter_map
  filter_map ~f:(fun i -> if i<2 then Some (i+1) else None) \
    [0; 1; 2] = [1; 2]
*)


let mapi ~f l =
  let rec recur i ls = function
    |[] -> ls
    |x::xs -> recur (i+1) ((f i x)::ls) xs
  in
  rev (recur 0 [] l)

(*$T mapi
  mapi ~f:(fun i x -> i+x) [0; 1; 2] = [0; 2; 4]
*)


let findi ~f l =
  let rec recur i = function
    |[] -> raise Not_found
    |x::xs -> if f i x then (i, x) else recur (i+1) xs
  in
  recur 0 l

(*$T findi
  findi ~f:(fun i x -> i = 2) [1; 2; 3] = (2, 3)
*)


let rfind ~f l = find ~f:f (rev l)

(*$T rfind
  rfind ~f:(fun x -> x < 4) [1;2;3;4;5] = 3
*)


let reduce ~f l =
  let rec recur p = function
    |[] -> p
    |x::xs -> recur (f p x) xs
    in
    match l with
    |[] -> raise Invalid_empty
    |x::xs -> recur x xs

(*$T reduce
  reduce ~f:(fun p x -> p+x) [1;2;3] = 6
*)

let unique ?(cmp=(=)) l =
  let rec recur ls = function
    |[] -> ls
    |x::xs ->
      if (exists ls ~f:(cmp x)) then recur ls xs
      else recur (x::ls) xs
  in
  rev (recur [] l)

(*$T unique
  unique [1;1;2;2;2] = [1; 2]
*)


let drop l n = snd (split_nth l n)

(*$T drop
  drop [1; 2; 3; 4; 5] 2 = [3; 4; 5]
*)


let drop_while ~f l =
  let rec recur = function
    |[] -> []
    |x::xs -> if f x then recur xs else x::xs
  in
  recur l

(*$T drop_while
  drop_while ~f:(fun x -> x<2) [1; 2; 3] = [2; 3]
*)


let remove ?(cmp=(=)) n l =
  let rec recur ls = function
    |[] -> (rev ls)
    |x::xs -> if (cmp n x) then (append (rev ls) xs) else recur (x::ls) xs
  in
  recur [] l

(*$T remove
  remove 1 [1; 2; 3; 1; 2; 3] =[2;3;1;2;3]
*)


let remove_all ?(cmp=(=)) n l =
  collect l ~f:(fun x -> if cmp x n then [] else [x])

(*$T remove_all
  remove_all 1 [1;2;3;1;2;3] = [2;3;2;3]
*)


let take l n = fst (split_nth l n)

(*$T take
  take [1; 2; 3] 2 = [1; 2]
*)


let take_while ~f l =
  let rec recur ls = function
    |[] -> ls
    |x::xs -> if f x then recur (x::ls) xs else ls
  in
  rev (recur [] l)

(*$T take_while
  take_while ~f:(fun x -> x=1) [1;1;1;2;2;1] = [1;1;1]
*)


let init ~f n =
  let rec recur i ls =
    if i<n then recur (i+1) ((f i)::ls)
    else ls
  in
  if n<0 then raise (Invalid_index n)
  else rev (recur 0 [])

(*$T init
  init ~f:(fun i -> i) 3 = [0;1;2]
*)


let make v n =
  let rec recur i ls =
    if i<n then recur (i+1) (v::ls)
    else ls
  in
  if n<0 then raise (Invalid_index n)
  else rev (recur 0 [])

(*$T make
  make 1 3 = [1;1;1]
*)


let sub l ~pos ~len =
  if (length l) < pos+len then invalid_arg "List.sub"
  else take (drop l pos) len

(*$T sub
  sub [1;2;3] ~pos:1 ~len:2 = [2;3]
*)


let slice l ~start ~stop =
  let len = length l in
  if len<=0 || len<start || len<stop || stop<start then invalid_arg "List.slice"
  else sub l ~pos:start ~len:(stop - start + 1)

(*$T slice
  slice [1;2;3] ~start:0 ~stop:1 = [1; 2]
*)


let of_array arr = Array.to_list arr
let to_array l = Array.of_list l

let (@) = append

module Infix = struct
  let (@) = append
end

module Optional = struct
  open Caramel_option
  let find ~f l = ret_option (find ~f:f) l
  let findi ~f l = ret_option (findi ~f:f) l
  let rfind ~f l = ret_option (rfind ~f:f) l
  let reduce ~f l = ret_option (reduce ~f:f) l
  let assoc n l = ret_option (assoc n) l
  let combine l m = ret_option (combine l) m
  let split_nth n l = ret_option (split_nth n) l
  let init ~f n = ret_option (init ~f:f) n
  let make n i = ret_option (make n) i
  let take l i = ret_option (take l) i
  let drop l i = ret_option (drop l) i
  let hd l = ret_option hd l
  let tl l = ret_option tl l
  let nth l i = ret_option (nth l) i
  let sub l ~pos ~len = ret_option (sub ~pos:pos ~len:len) l
  let slice l ~start ~stop = ret_option (slice ~start:start ~stop:stop) l
end


module Of_either = struct
  open Caramel_either
  let find ~f l = ret_either (find ~f:f) l
  let findi ~f l = ret_either (findi ~f:f) l
  let rfind ~f l = find ~f:f (rev l)
  let reduce ~f l = ret_either (reduce ~f:f) l
  let assoc n l = ret_either (assoc n) l
  let combine l m = ret_either (combine l) m
  let split_nth l n = ret_either (split_nth l) n
  let init ~f n = ret_either (init ~f:f) n
  let make n i = ret_either (make n) i
  let take l i = ret_either (take l) i
  let drop l i = ret_either (drop l) i
  let hd l = ret_either hd l
  let tl l = ret_either tl l
  let nth l i = ret_either (nth l) i
  let sub l ~pos ~len = ret_either (sub ~pos:pos ~len:len) l
  let slice l ~start ~stop = ret_either (slice ~start:start ~stop:stop) l
end

module ListMonad = Caramel_monad.Make(struct
  type 'a t = 'a list

  let bind l f = List.concat (List.map f l)
  let return x = [ x ]
end)
