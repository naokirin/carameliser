module List = struct
  include ListLabels

  exception Invalid_index of int
  exception Invalid_empty

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

  let is_empty = function
    |[] -> true
    |_ -> false

  let iteri ~f l =
    ignore (fold_left ~f:(fun i x -> f i x; i+1) ~init:0 l)

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

  let filter_map ~f l =
    rev (rev_filter_map ~f:f l)

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

  let of_array arr =
    Array.to_list arr

  let to_array l =
    Array.of_list l

  module Exceptionless = struct
    let try_find ~f l =
      let rec recur = function
        |[] -> None
        |x::xs -> if f x then Some x else recur xs
      in
      recur l

    let try_findi ~f l =
      let rec recur i = function
        |[] -> None
        |x::xs -> if f i x then Some (i, x) else recur (i+1) xs
      in
      recur 0 l

    let try_rfind ~f l = try_find ~f:f List.(rev l)

    let try_reduce ~f l =
    let open Caramel_either.Either in
      ret_either (reduce ~f:f) l

    let try_assoc n l =
      let open Caramel_either.Either in
      ret_either List.(assoc n) l
                                                                                let try_combine l m =
      let open Caramel_either.Either in
      ret_either List.(combine l) m

    let try_split_nth l n=
      let open Caramel_either.Either in
      ret_either (split_nth l) n

    let try_init ~f n =
      let open Caramel_either.Either in
      ret_either (init ~f:f) n

    let try_make n i =
      let open Caramel_either.Either in
      ret_either (make n) i

    let try_take l i =
      let open Caramel_either.Either in
      ret_either (take l) i

    let try_drop l i =
      let open Caramel_either.Either in
      ret_either (drop l) i

    let try_hd l =
      let open Caramel_either.Either in
      ret_either hd l

    let try_tl l =
      let open Caramel_either.Either in
      ret_either tl l

    let try_nth l i =
      let open Caramel_either.Either in
      ret_either (nth l) i
  end
end
