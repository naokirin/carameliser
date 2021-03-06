
module T = struct
  type 'a t = 'a array
end

include T


let length = ArrayLabels.length
let get = ArrayLabels.get
let set = ArrayLabels.set
let make = ArrayLabels.make
let create = ArrayLabels.create
let init = ArrayLabels.init
let make_matrix = ArrayLabels.make_matrix
let create_matrix = ArrayLabels.create_matrix
let append = ArrayLabels.append
let concat = ArrayLabels.concat
let sub = ArrayLabels.sub
let copy = ArrayLabels.copy
let fill = ArrayLabels.fill
let blit = ArrayLabels.blit
let to_list = ArrayLabels.to_list
let of_list = ArrayLabels.of_list
let iter = ArrayLabels.iter
let map = ArrayLabels.map
let iteri = ArrayLabels.iteri
let mapi = ArrayLabels.mapi
let fold_left = ArrayLabels.fold_left
let fold_right = ArrayLabels.fold_right
let sort = ArrayLabels.sort
let stable_sort = ArrayLabels.stable_sort
let fast_sort = ArrayLabels.fast_sort
let unsafe_get = ArrayLabels.unsafe_get
let unsafe_set = ArrayLabels.unsafe_set


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


module Optional = struct
  module Opt = Caramel_option
  let reduce ~f arr = Opt.ret_option (reduce ~f:f) arr
  let combine arr1 arr2 = Opt.ret_option (combine arr1) arr2
  let find ~f arr = Opt.ret_option (find ~f:f) arr
  let findi ~f arr = Opt.ret_option (findi ~f:f) arr
  let find_all ~f arr = Opt.ret_option (find_all ~f:f) arr
  let get arr i = Opt.ret_option (get arr) i
  let make n x = Opt.ret_option (make n) x
  let init i ~f = Opt.ret_option (init ~f:f) i
  let make_matrix ~dimx ~dimy n =
    Opt.ret_option (make_matrix ~dimx:dimx ~dimy:dimy) n
  let sub arr ~pos ~len = Opt.ret_option (sub ~pos:pos ~len:len) arr
end


module Of_either = struct
  module E = Caramel_either
  let reduce ~f arr = E.ret_either (reduce ~f:f) arr
  let combine arr1 arr2 = E.ret_either (combine arr1) arr2
  let find ~f arr = E.ret_either (find ~f:f) arr
  let findi ~f arr = E.ret_either (findi ~f:f) arr
  let find_all ~f arr = E.ret_either (find_all ~f:f) arr
  let get arr i = E.ret_either (get arr) i
  let make n x = E.ret_either (make n) x
  let init i ~f = E.ret_either (init ~f:f) i
  let make_matrix ~dimx ~dimy n =
    E.ret_either (make_matrix ~dimx:dimx ~dimy:dimy) n
  let sub arr ~pos ~len = E.ret_either (sub ~pos:pos ~len:len) arr
end

