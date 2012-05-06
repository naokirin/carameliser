
include ArrayLabels

type 'a t = 'a array

let add_last n arr =
  append arr [|n|]

let add_first n arr =
  append [|n|] arr

let hd arr = arr.(0)

let tl arr = sub ~pos:1 ~len:((length arr)-1) arr

let filter ~f arr =
  let rec recur arrs = function
    | [||] -> arrs
    | _ as a ->
      if f a.(0) then recur (add_last a.(0) arrs) (tl a)
      else recur arrs (tl a)
  in
  recur [||] arr

let filter_map ~f arr =
  let rec recur arrs = function
    | [||] -> arrs
    | _ as a ->
      match f (hd a) with
      | Some x -> recur (add_last x arrs) (tl a)
      | None -> recur arrs (tl a)
  in
  recur [||] arr

let reduce ~f arr =
  let rec recur n = function
    | [||] -> n
    | _ as a -> recur (f n a.(0)) (tl a)
  in
  if length arr < 2 then invalid_arg "Array.reduce"
  else recur arr.(0) (tl arr)

let combine arr1 arr2 =
  let rec recur arrs a1 = function
    | [||] -> arrs
    | _ as a -> recur (add_last ((hd a1), (hd a)) arrs) (tl a1) (tl a)
  in
  if length arr1 <> length arr2 then invalid_arg "Array.combine"
  else recur [||] arr1 arr2

let replace ~f arr i =
  let arr1 = (copy arr) in
  arr1.(i) <- f arr.(i); arr1

let split arr =
  fold_left ~init:([||], [||]) ~f:(fun result a -> ((add_last (fst a) (fst result)), (add_last (snd a) (snd result)))) arr

let is_empty = function
  | [||] -> true
  | _ -> false
