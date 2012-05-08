
include ArrayLabels

type 'a t = 'a array

let add_last n arr =
  append arr [|n|]

(*$T add_last
  add_last 3 [|1;2|] = [|1; 2; 3|]
*)


let add_first n arr =
  append [|n|] arr

(*$T add_first
  add_first 1 [|2; 3|] = [|1; 2; 3|]
*)


let hd arr = arr.(0)

(*$T hd
  hd [|1; 2; 3|] = 1
*)


let tl arr = sub ~pos:1 ~len:((length arr)-1) arr

(*$T tl
  tl [|1; 2; 3|] = [|2; 3|]
*)


let filter ~f arr =
  let rec recur arrs = function
    | [||] -> arrs
    | _ as a ->
      if f a.(0) then recur (add_last a.(0) arrs) (tl a)
      else recur arrs (tl a)
  in
  recur [||] arr

(*$T filter
  filter ~f:(fun n -> n<3) [|1; 2; 3; 4|] = [|1; 2|]
*)


let filter_map ~f arr =
  let rec recur arrs = function
    | [||] -> arrs
    | _ as a ->
      match f (hd a) with
      | Some x -> recur (add_last x arrs) (tl a)
      | None -> recur arrs (tl a)
  in
  recur [||] arr

(*$T filter_map
  filter_map ~f:(fun n -> if n<3 then Some (n) else None) [|1;2;3;4|] \
    = [|1; 2|]
*)


let reduce ~f arr =
  let rec recur n = function
    | [||] -> n
    | _ as a -> recur (f n a.(0)) (tl a)
  in
  if length arr < 2 then invalid_arg "Array.reduce"
  else recur arr.(0) (tl arr)

(*$T reduce
  reduce ~f:(fun n a -> n+a) [|1;2;3;4|] = 10
*)


let combine arr1 arr2 =
  let rec recur arrs a1 = function
    | [||] -> arrs
    | _ as a -> recur (add_last ((hd a1), (hd a)) arrs) (tl a1) (tl a)
  in
  if length arr1 <> length arr2 then invalid_arg "Array.combine"
  else recur [||] arr1 arr2

(*$T combine
  combine [|1;2|] [|3;4|] = [|(1,3); (2,4)|]
*)


let replace ~f arr i =
  let arr1 = (copy arr) in
  arr1.(i) <- f arr.(i); arr1

(*$T replace
  replace ~f:(fun i -> i+1) [|1;2;3|] 1 = [|1;3;3|]
*)


let split arr =
  fold_left ~init:([||], [||]) ~f:(fun result a -> ((add_last (fst a) (fst result)), (add_last (snd a) (snd result)))) arr

(*$T split
  split [|(1,2); (3,4)|] = ([|1; 3|], [|2; 4|])
*)


let is_empty = function
  | [||] -> true
  | _ -> false

(*$T is_empty
  is_empty [||]
  not (is_empty [|1|])
*)


let collect ~f arr =
  let rec recur = function
    | [||] -> [||]
    | _ as a ->
      append (f (hd a)) (recur (tl a))
  in
  recur arr

let exists ~f arr =
  fold_left ~f:(fun p n -> p || (f n)) ~init:false arr

let for_all ~f arr =
  if is_empty arr then false
  else fold_left ~f:(fun p n -> p && (f n)) ~init:true arr

let rec find ~f = function
  | [||] -> raise Not_found
  | _ as a -> if f (hd a) then (hd a) else find ~f:f (tl a)

let findi ~f arr =
  let rec recur i = function
    | [||] -> raise Not_found
    | _ as a ->
      let n = hd a in
      if f i n then (i, n) else recur (i+1) (tl a)
  in recur 0 arr

let find_all ~f arr =
  let rec recur arrs = function
    | [||] -> if is_empty arrs then raise Not_found else arrs
    | _ as a ->
      let n = hd a in
      if f n then recur (add_last n arrs) (tl a) else recur arrs (tl a)
  in
  recur [||] arr
