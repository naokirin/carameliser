open OUnit
open Caramel.Array

let test =
  "Caramel_array" >:::
  [
    "add_last" >:: (fun () ->
      assert_equal ~msg:"add 5"
        (add_last 5 [|1; 2; 3; 4|]) [|1; 2; 3; 4; 5|];
      assert_equal ~msg:"empty"
        (add_last 1 [||]) [|1|]);

    "add_first" >:: (fun () ->
      assert_equal ~msg:"add 1"
        (add_first 1 [|2; 3; 4; 5|]) [|1; 2; 3; 4; 5|];
      assert_equal ~msg:"empty"
        (add_first 1 [||]) [|1|]);

    "hd" >:: (fun () ->
      assert_equal ~msg:"is 1"
        (hd [|1; 2; 3|]) 1);

    "tl" >:: (fun () ->
      assert_equal ~msg:"is [|2; 3|]"
        (tl [|1; 2 ;3|]) [|2; 3|]);

    "filter" >:: (fun () ->
        assert_equal ~msg:"removes 1"
          (filter ~f:(fun i -> i<>1) [|1; 2; 1; 3|]) [|2; 3|]);

    "filter_map" >:: (fun () ->
      assert_equal ~msg:"removes x>3"
        (filter_map ~f:(fun x -> if x<=3 then Some x else None) [|2; 3; 4|]) [|2; 3|]);

    "reduce" >:: (fun () ->
      assert_equal ~msg:"1+2+3"
        (reduce ~f:(fun p n -> p+n) [|1; 2; 3|]) 6);

    "combine" >:: (fun () ->
      assert_equal ~msg:"combine"
        (combine [|1; 2; 3|] [|4; 5; 6|]) [|(1, 4); (2, 5); (3, 6)|]);

    "replace" >:: (fun () ->
      assert_equal ~msg:"replace 1 to 2"
        (replace ~f:(fun i -> i+1)[|0; 1; 2|] 1) [|0; 2; 2|]);

    "split" >:: (fun () ->
      assert_equal ~msg:"split 1"
        (split [|(1, 2); (3, 4); (5, 6)|]) ([|1;3;5|], [|2;4;6|]));

    "is_empty" >:: (fun () ->
      "empty" @? is_empty [||];
      "not empty" @? not (is_empty [|1|]))
  ]
