include Num

let num_of_float x =
  let rec recur n d =
    match n -. (float_of_int (int_of_float n)) with
    | 0. -> (Int(int_of_float n) // Int(int_of_float d))
    | _ -> recur (n*.10.) (d*.10.)
  in
  recur x 1.
