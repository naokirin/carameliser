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
