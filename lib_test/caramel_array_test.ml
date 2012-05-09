open OUnit
open Caramel.Array

let test =
  "Caramel_array" >::: [
    "add_last" >:: (fun () ->
      assert_equal ~msg:"add 5"
        [|1; 2; 3; 4; 5|] (add_last 5 [|1; 2; 3; 4|]);
      assert_equal ~msg:"empty"
        [|1|] (add_last 1 [||]));

    "add_first" >:: (fun () ->
      assert_equal ~msg:"add 1"
        [|1; 2; 3; 4; 5|] (add_first 1 [|2; 3; 4; 5|]);
      assert_equal ~msg:"empty"
        [|1|] (add_first 1 [||]));

    "hd" >:: (fun () ->
      assert_equal ~msg:"is 1"
        1 (hd [|1; 2; 3|]));

    "tl" >:: (fun () ->
      assert_equal ~msg:"is [|2; 3|]"
        [|2; 3|] (tl [|1; 2 ;3|]));

    "filter" >:: (fun () ->
      assert_equal ~msg:"removes 1"
        [|2; 3|] (filter ~f:(fun i -> i<>1) [|1; 2; 1; 3|]));

    "filter_map" >:: (fun () ->
      assert_equal ~msg:"removes x>3"
        [|2; 3|] (filter_map ~f:(fun x -> if x<=3 then Some x else None) [|2; 3; 4|]));

    "reduce" >:: (fun () ->
      assert_equal ~msg:"1+2+3"
        6 (reduce ~f:(fun p n -> p+n) [|1; 2; 3|]));

    "combine" >:: (fun () ->
      assert_equal ~msg:"combine"
        [|(1, 4); (2, 5); (3, 6)|] (combine [|1; 2; 3|] [|4; 5; 6|]));

    "replace" >:: (fun () ->
      assert_equal ~msg:"replace 1 to 2"
        [|0; 2; 2|] (replace ~f:(fun i -> i+1)[|0; 1; 2|] 1));

    "split" >:: (fun () ->
      assert_equal ~msg:"split 1"
        ([|1;3;5|], [|2;4;6|]) (split [|(1, 2); (3, 4); (5, 6)|]));

    "is_empty" >:: (fun () ->
      "empty" @? is_empty [||];
      "not empty" @? not (is_empty [|1|]));

    "collect" >:: (fun () ->
      assert_equal ~msg:"collect"
        [|2;3;3;4|] (collect ~f:(fun n -> [|n+1; n+2|]) [|1; 2|]));

    "exists" >:: (fun () ->
      "exists" @? (exists ~f:(fun n -> n=1) [|0;1;2|]);
      "not exists" @? not (exists ~f:(fun n -> n=1) [|0; 2; 3|]);
      "empty" @? not (exists ~f:(fun n -> n=1) [||]));

    "for_all" >:: (fun () ->
      "for_all" @? (for_all ~f:(fun n -> n=1) [|1; 1; 1|]);
      "not for_all" @? not (for_all ~f:(fun n -> n=1) [|1; 1; 2|]);
      "empty" @? not (for_all ~f:(fun n -> n=1) [||]));

    "find" >:: (fun () ->
      assert_equal ~msg:"find 1"
        1 (find ~f:(fun n -> n=1) [|1; 2; 3|]);
      assert_equal ~msg:"greater than 2"
        3 (find ~f:(fun n -> n>2) [|1;2;3;4|]);
      assert_raises ~msg:"not found"
        Not_found (fun () -> find ~f:(fun n -> n=1) [|2;3|]);
      assert_raises ~msg:"empty"
        Not_found (fun () -> find ~f:(fun n -> n=1) [||]));

    "findi" >:: (fun () ->
      assert_equal ~msg:"find i+n=3"
        (1, 2) (findi ~f:(fun i n -> i+n=3) [|1;2;3|]);
      assert_raises ~msg:"not found"
        Not_found (fun () -> findi ~f:(fun i n -> i+n=3) [|1;1|]);
      assert_raises ~msg:"empty"
        Not_found (fun () -> findi ~f:(fun i n -> true) [||]););

    "find_all" >:: (fun () ->
      assert_equal ~msg:"greater than 2"
        [|3;4|] (find_all ~f:(fun n -> n>2) [|1;2;3;4|]);
      assert_raises ~msg:"not found"
        Not_found (fun () -> find_all ~f:(fun n -> n=1) [|2;3|]);
      assert_raises ~msg:"empty"
        Not_found (fun () -> find_all ~f:(fun n -> n=1) [||]));
  ]
