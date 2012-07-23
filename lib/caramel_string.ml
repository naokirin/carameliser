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

let explode str =
  let result = ref [] in
  iter (fun c -> result := c::!result) str; Caramel_list.rev !result

let collect lst =
  Caramel_list.fold_left ~f:(fun p n -> p ^ (string_of_char n)) ~init:"" lst

module Optional = struct
  module O = Caramel_option
  let get str n = O.ret_option (get str) n
  let create n = O.ret_option create n
  let make n c = O.ret_option (make n) c
  let sub str ~pos ~len = O.ret_option (sub ~pos:pos ~len:len) str
  let index str c = O.ret_option (index str) c
  let rindex str c = O.ret_option (rindex str) c
  let index_from str n c = O.ret_option (index_from str n) c
  let rindex_from str n c = O.ret_option (rindex_from str n) c
  let contains_from str n c = O.ret_option (contains_from str n) c
  let rcontains_from str n c = O.ret_option (rcontains_from str n) c
  let hd str = O.ret_option hd str
  let tl str = O.ret_option tl str
end

module Of_either = struct
  module E = Caramel_either
  let get str n = E.ret_either (get str) n
  let create n = E.ret_either create n
  let make n c = E.ret_either (make n) c
  let sub str ~pos ~len = E.ret_either (sub ~pos:pos ~len:len) str
  let index str c = E.ret_either (index str) c
  let rindex str c = E.ret_either (rindex str) c
  let index_from str n c = E.ret_either (index_from str n) c
  let rindex_from str n c = E.ret_either (rindex_from str n) c
  let contains_from str n c = E.ret_either (contains_from str n) c
  let rcontains_from str n c = E.ret_either (rcontains_from str n) c
  let hd str = E.ret_either hd str
  let tl str = E.ret_either tl str
end
