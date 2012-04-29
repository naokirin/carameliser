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
    let rec recur p = function
      |[] -> Some p
      |x::xs -> recur (f p x) xs
    in
    match l with
    |[] -> None
    |x::xs -> recur x xs

  let try_assoc n l =
    let open Caramel_either.Either in
    ret_either List.(assoc n) l

  let try_combine l m =
    let open Caramel_either.Either in
    ret_either List.(combine l) m

  let try_split_nth n l =
    let open List in
    let open Caramel_either in
    let rec recur i ls = function
      |[] -> ((rev ls), [])
      |x::xs -> if (n <= i) then ((rev ls), x::xs) else recur (i+1) (x::ls)     xs
    in
    if n < 0 || n > (length l) then Left (Invalid_index n)
    else Right (recur 0 [] l)
end
