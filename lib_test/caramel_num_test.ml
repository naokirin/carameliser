open OUnit
open Caramel.Num

let test =
  "Caramel_num" >::: [
    "num_of_float" >:: (fun () ->
      assert_equal ~msg:"1.1 equals 11/10"
        1.1 (float_of_num (num_of_float 1.1));
      assert_equal ~msg:"1.110111 equals 1110111/1000000"
        1.110111 (float_of_num (num_of_float 1.110111)));
  ]

