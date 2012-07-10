type t = string

let length = StringLabels.length
let get = StringLabels.get
let set = StringLabels.set
let create = StringLabels.create
let make = StringLabels.make
let copy = StringLabels.copy
let sub = StringLabels.sub
let fill = StringLabels.fill
let blit = StringLabels.blit
let concat = StringLabels.concat
let iter = StringLabels.iter
let escaped = StringLabels.escaped
let index = StringLabels.index
let rindex = StringLabels.rindex
let index_from = StringLabels.index_from
let rindex_from = StringLabels.rindex_from
let contains = StringLabels.contains
let contains_from = StringLabels.contains_from
let rcontains_from = StringLabels.rcontains_from
let uppercase = StringLabels.uppercase
let lowercase = StringLabels.lowercase
let capitalize = StringLabels.capitalize
let uncapitalize = StringLabels.uncapitalize
let compare = StringLabels.compare
let unsafe_get = StringLabels.unsafe_get
let unsafe_set = StringLabels.unsafe_set
let unsafe_blit = StringLabels.unsafe_blit
let unsafe_fill = StringLabels.unsafe_fill

let is_empty = function "" -> true | _ -> false

let hd str = if is_empty str then raise (Failure "hd") else get str 0

let tl str = if is_empty str then raise (Failure "tl") else sub ~pos:1 ~len:((length str) -1) str

let string_of_char c = make 1 c
