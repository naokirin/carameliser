(*module T = struct
  type t = string
end

include T*)
include StringLabels

let is_empty = function "" -> true | _ -> false

let hd str = if is_empty str then raise (Failure "hd") else get str 0

let tl str = if is_empty str then raise (Failure "tl") else sub ~pos:1 ~len:((length str) -1) str

let string_of_char c = make 1 c

