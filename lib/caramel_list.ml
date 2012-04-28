module List = struct
  include ListLabels

  include Caramel_list_exceptionless

  exception Invalid_index of int

  let split_nth n l =
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
    match (Exceptionless.try_reduce l ~f:f) with
    |None -> invalid_arg "The list is empty."
    |Some x -> x

  let unique ?(cmp=(=)) l =
    let rec recur ls = function
      |[] -> ls
      |x::xs ->
        if (exists ls ~f:(cmp x)) then recur ls xs
        else recur (x::ls) xs
    in
    rev (recur [] l)

  let drop n l = snd (split_nth n l)

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

  let take n l = fst (split_nth n l)

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

  let make n v =
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
end
