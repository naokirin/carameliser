module List = struct
  include ListLabels

  exception Invalid_index of int
  exception Invalid_empty

  let is_empty = function
    |[] -> true
    |_ -> false

  let split_nth l n =
    let rec recur i ls = function
      |[] -> ((rev ls), [])
      |x::xs -> if (n <= i) then ((rev ls), x::xs) else recur (i+1) (x::ls) xs
    in
    if n < 0 || n > (length l) then raise (Invalid_index n)
    else recur 0 [] l

  let split_while ~f l =
    let rec recur ls = function
      |[] -> ((rev ls), [])
      |x::xs -> if f x then recur (x::ls) xs else ((rev ls), x::xs)
    in
    recur [] l

  let iteri ~f l = ignore (fold_left ~f:(fun i x -> f i x; i+1) ~init:0 l)

  let collect ~f l =
    let rec recur ls = function
      |[] -> ls
      |x::xs -> recur (append ls (f x)) xs
    in
    recur [] l

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

  let mapi ~f l =
    let rec recur i ls = function
      |[] -> ls
      |x::xs -> recur (i+1) ((f i x)::ls) xs
    in
    rev (recur 0 [] l)

  let findi ~f l =
    let rec recur i = function
      |[] -> raise Not_found
      |x::xs -> if f i x then (i, x) else recur (i+1) xs
    in
    recur 0 l

  let rfind ~f l = find ~f:f (rev l)

  let reduce ~f l =
    let rec recur p = function
      |[] -> p
      |x::xs -> recur (f p x) xs
      in
      match l with
      |[] -> raise Invalid_empty
      |x::xs -> recur x xs

  let unique ?(cmp=(=)) l =
    let rec recur ls = function
      |[] -> ls
      |x::xs ->
        if (exists ls ~f:(cmp x)) then recur ls xs
        else recur (x::ls) xs
    in
    rev (recur [] l)

  let drop l n = snd (split_nth l n)

  let drop_while ~f l =
    let rec recur = function
      |[] -> []
      |x::xs -> if f x then recur xs else x::xs
    in
    recur l

  let remove ?(cmp=(=)) n l =
    let rec recur ls = function
      |[] -> (rev ls)
      |x::xs -> if (cmp n x) then (append (rev ls) xs) else recur (x::ls) xs
    in
    recur [] l

  let remove_all ?(cmp=(=)) n l =
    collect l ~f:(fun x -> if cmp x n then [] else [x])

  let take l n = fst (split_nth l n)

  let take_while ~f l =
    let rec recur ls = function
      |[] -> ls
      |x::xs -> if f x then recur (x::ls) xs else ls
    in
    rev (recur [] l)

  let init ~f n =
    let rec recur i ls =
      if i<n then recur (i+1) ((f i)::ls)
      else ls
    in
    if n<0 then raise (Invalid_index n)
    else rev (recur 0 [])

  let make v n =
    let rec recur i ls =
      if i<n then recur (i+1) (v::ls)
      else ls
    in
    if n<0 then raise (Invalid_index n)
    else rev (recur 0 [])

  let of_array arr = Array.to_list arr
  let to_array l = Array.of_list l


  module Optional = struct
    open Caramel_option.Option
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
  end


  module Exceptionless = struct
    open Caramel_either.Either
    let try_find ~f l = ret_either (find ~f:f) l
    let try_findi ~f l = ret_either (findi ~f:f) l
    let try_rfind ~f l = try_find ~f:f (rev l)
    let try_reduce ~f l = ret_either (reduce ~f:f) l
    let try_assoc n l = ret_either (assoc n) l
    let try_combine l m = ret_either (combine l) m
    let try_split_nth l n = ret_either (split_nth l) n
    let try_init ~f n = ret_either (init ~f:f) n
    let try_make n i = ret_either (make n) i
    let try_take l i = ret_either (take l) i
    let try_drop l i = ret_either (drop l) i
    let try_hd l = ret_either hd l
    let try_tl l = ret_either tl l
    let try_nth l i = ret_either (nth l) i
  end
end
