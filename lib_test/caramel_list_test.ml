open OUnit
open Caramel
open Caramel.List

let test =
  "Caramel_list" >:::
  [
    "split_nth" >::
      (fun () ->
        assert_equal ~msg:"split_0th" ([], [1;2;3]) (split_nth [1;2;3] 0);
        assert_equal ~msg:"split_1st" ([1], [2;3]) (split_nth [1;2;3] 1);
        assert_equal ~msg:"empty" ([], []) (split_nth [] 0);
        assert_equal ~msg:"length" ([1;2;3], []) (split_nth [1;2;3] 3);
        assert_raises ~msg:"over" (Invalid_index 4) (fun () -> split_nth [1;2;3] 4);
        assert_raises ~msg:"minus" (Invalid_index ~-1) (fun () -> split_nth [1;2;3] ~-1));

    "split_while" >::
      (fun () ->
        assert_equal ~msg:"split_1"
          ([], [1; 2; 3]) (split_while [1; 2; 3] ~f:(fun n -> n<1));
        assert_equal ~msg:"split_2"
          ([1], [2; 3]) (split_while [1; 2; 3] ~f:(fun n -> n<2));
        assert_equal ~msg:"over"
          ([1;2;3], []) (split_while [1;2;3] ~f:(fun n -> n<4));
        assert_equal ~msg:"empty"
          ([], []) (split_while [] ~f:(fun n -> n=0)));

    "is_empty" >::
      (fun () ->
        "empty" @? (is_empty []);
        "not empty1" @? (not (is_empty [1]));
        "not empty2" @? (not (is_empty [""]));
        "not empty3" @? (not (is_empty [1; 2])));

    "iteri" >::
      (fun () ->
        let result = ref 0 in
        iteri [1] ~f:(fun i x -> result := i+x);
        assert_equal ~msg:"list" 1 !result);

    "collect" >::
      (fun () ->
        assert_equal ~msg:"plus_1"
          [1; 2; 3] (collect [0; 1; 2] ~f:(fun i -> [i+1]));
        assert_equal ~msg:"empty"
        [] (collect [] ~f:(fun i -> [i]));
        assert_equal ~msg:"length 1"
          [1] (collect [0] ~f:(fun i -> [i+1])));

    "filter_map" >::
      (fun () ->
        assert_equal ~msg:"greater than 3"
          [4; 5; 6] (filter_map [1; 2; 3; 4; 5; 6]
            ~f:(fun x ->(if (x>3) then (Some x) else None))));

    "mapi" >::
      (fun () ->
        assert_equal ~msg:"index + data"
          [1; 2; 3; 4] (mapi [1; 1; 1; 1] ~f:(fun i x -> i+x));
        assert_equal ~msg:"'index' ^ 'data'"
          ["0a"; "1b"; "2c"] (mapi ["a"; "b"; "c"] ~f:(fun i x -> (string_of_int i) ^ x)));

    "try_find" >::
      (fun () ->
        assert_equal ~msg:"found"
          (Some 2) (Exceptionless.try_find [1; 2; 3] ~f:(fun n -> n=2));
        assert_equal ~msg:"not found"
          None (Exceptionless.try_find [1; 2; 3] ~f:(fun n -> n=5)));

    "findi" >::
      (fun () ->
        assert_equal ~msg:"found"
          (1, 2) (findi [1; 2; 3] ~f:(fun i n -> n=2 && i=1));
        assert_raises ~msg:"not found"
          (Not_found) (fun () -> findi [1; 2; 3] ~f:(fun i n -> n=5)));

    "try_findi" >::
      (fun () ->
        assert_equal ~msg:"found"
          (Some (1, 2)) (Exceptionless.try_findi [1;2;3] ~f:(fun i n -> n=2 && i=1));
        assert_equal ~msg:"not_found"
          None (Exceptionless.try_findi [1;2;3] ~f:(fun i n -> n=5)));

    "rfind" >::
      (fun () ->
        assert_equal ~msg:"found"
          4 (rfind [1; 2; 3; 4; 5] ~f:(fun n -> (n mod 2)=0));
        assert_raises ~msg:"not found"
          (Not_found) (fun () -> rfind [1; 2; 3] ~f:(fun n -> n=5)));

    "try_rfind" >::
      (fun () ->
        assert_equal ~msg:"found"
          (Some 4) (Exceptionless.try_rfind [1;2;3;4;5] ~f:(fun n -> (n mod 2)=0));
        assert_equal ~msg:"not found"
          None (Exceptionless.try_rfind [1;2;3] ~f:(fun n -> n=5)));

    "reduce" >::
      (fun () ->
        assert_equal ~msg:"add 1..5"
          15 (reduce [1; 2; 3; 4; 5] ~f:(+));
        assert_equal ~msg:"concat string"
          "abcd" (reduce ["a"; "b"; "c"; "d"] ~f:(^));
        assert_raises ~msg:"list should not be empty"
          (Invalid_empty) (fun () -> reduce [] ~f:(+)));

    "try_reduce" >::
      (fun () ->
        assert_equal ~msg:"add 1..5"
          (Right 15) (Exceptionless.try_reduce [1; 2; 3; 4; 5] ~f:(+));
        assert_equal ~msg:"concat string"
          (Right "abcd") (Exceptionless.try_reduce ["a"; "b"; "c"; "d"] ~f:(^));
        assert_equal ~msg:"empty"
          (Left Invalid_empty) (Exceptionless.try_reduce [] ~f:(+)));

    "unique" >::
      (fun () ->
        assert_equal ~msg:"[1; 1]"
          [1] (unique [1; 1]);
        assert_equal ~msg:"[1;2;3;1;2;3]"
          [1; 2; 3] (unique [1;2;3;1;2;3]));

    "drop" >::
      (fun () ->
        assert_equal ~msg:"drop1"
          [2;3] (drop [1; 2; 3] 1);
        assert_raises ~msg:"over"
          (Invalid_index 4) (fun () -> drop [1; 2; 3] 4));

    "drop_while" >::
      (fun () ->
        assert_equal ~msg:"drop_while1"
          [4;5] (drop_while [1;2;3;4;5] ~f:(fun n -> n<4));
        assert_equal ~msg:"empty"
          [] (drop_while [] ~f:(fun n -> true)));

    "remove" >::
      (fun () ->
        assert_equal ~msg:"remove"
          [1; 3] (remove 2 [1; 2; 3]);
        assert_equal ~msg:"remove nothing"
          [1; 2; 3] (remove 4 [1; 2; 3]);
        assert_equal ~msg:"empty"
          [] (remove 1 []));

    "remove_all" >::
      (fun () ->
        assert_equal ~msg:"remove_all"
          [1] (remove_all 2 [2; 1; 2]);
        assert_equal ~msg:"remove nothing"
          [1; 2; 3] (remove_all 4 [1; 2; 3]);
        assert_equal ~msg:"empty"
          [] (remove_all 1 []));

    "take" >::
      (fun () ->
        assert_equal ~msg:"take 1"
          [1] (take [1;2;3] 1);
        assert_equal ~msg:"take 0"
          [] (take [1;2;3] 0);
        assert_raises ~msg:"empty"
          (Invalid_index 1) (fun () -> take [] 1);
        assert_raises ~msg:"minus"
          (Invalid_index ~-1) (fun () -> take [1;2;3] ~-1));

    "take_while" >::
      (fun () ->
        assert_equal ~msg:"take_while n<3"
          [1;2] (take_while [1;2;3] ~f:(fun n -> n<3));
        assert_equal ~msg:"empty"
          [] (take_while [] ~f:(fun n -> true)));

    "init" >::
      (fun () ->
        assert_equal ~msg:"init 1"
          [1] (init ~f:(fun n -> 1) 1);
        assert_equal ~msg:"init 2"
          [1;2;3] (init ~f:(fun n -> n+1) 3);
        assert_equal ~msg:"empty"
          [] (init ~f:(fun n -> 1) 0);
        assert_raises ~msg:"minus"
          (Invalid_index ~-1) (fun () -> init ~f:(fun n -> 1) ~-1));

    "make" >::
      (fun () ->
        assert_equal ~msg:"make 1"
          [1] (make 1 1);
        assert_equal ~msg:"make 2"
          [1;1;1] (make 1 3);
        assert_equal ~msg:"empty"
          [] (make 0 0);
        assert_raises ~msg:"minus"
          (Invalid_index ~-1) (fun () -> make 0 ~-1));

    "of_array" >::
      (fun () ->
        assert_equal ~msg:"[|1; 2; 3|]"
          [1; 2; 3] (of_array [|1; 2; 3|]));

    "to_array" >::
      (fun () ->
        assert_equal ~msg:"[1; 2; 3]"
          [|1; 2; 3|] (to_array [1; 2; 3]));

    "try_assoc" >::
      (fun () ->
        assert_equal ~msg:"found"
          (Right "a") (Exceptionless.try_assoc 1 [(1, "a"); (2, "b")]);
        assert_equal ~msg:"not found"
          (Left Not_found) (Exceptionless.try_assoc 1 [(2, "b")]));

    "try_combine" >::
      (fun () ->
        assert_equal ~msg:"combine"
          (Right [(1, 2); (3, 4)]) (Exceptionless.try_combine [1; 3] [2; 4]);
        assert_equal ~msg:"failure"
          (Left (Invalid_argument "List.combine")) (Exceptionless.try_combine [1;2] [1]));

    "try_split_nth" >::
      (fun () ->
        assert_equal ~msg:"split"
          (Right ([1], [2;3])) (Exceptionless.try_split_nth [1;2;3] 1);
        assert_equal ~msg:"failure"
          (Left (Invalid_index 1)) (Exceptionless.try_split_nth [] 1));

    "try_init" >::
      (fun () ->
        assert_equal ~msg:"init"
          (Right [1;1;1]) (Exceptionless.try_init ~f:(fun i -> 1) 3);
        assert_equal ~msg:"failure"
          (Left (Invalid_index ~-1)) (Exceptionless.try_init ~f:(fun i -> 1)~-1));

    "try_make" >::
      (fun () ->
        assert_equal ~msg:"make"
          (Right [1;1;1]) (Exceptionless.try_make 1 3);
        assert_equal ~msg:"failure"
          (Left (Invalid_index ~-1)) (Exceptionless.try_make 1 ~-1));

    "try_take" >::
      (fun () ->
        assert_equal ~msg:"take"
          (Right [1;2]) (Exceptionless.try_take [1;2;3] 2);
        assert_equal ~msg:"failure"
          (Left (Invalid_index ~-1)) (Exceptionless.try_take [1;2;3] ~-1));

    "try_drop" >::
      (fun () ->
        assert_equal ~msg:"drop"
          (Right [2;3]) (Exceptionless.try_drop [1;2;3] 1);
        assert_equal ~msg:"failure"
          (Left (Invalid_index ~-1)) (Exceptionless.try_drop [1;2;3] ~-1));

    "try_hd" >::
      (fun () ->
        assert_equal ~msg:"hd"
          (Right 1) (Exceptionless.try_hd [1;2;3]);
        assert_equal ~msg:"failure"
          (Left (Failure "hd")) (Exceptionless.try_hd []));

    "try_tl" >::
      (fun () ->
        assert_equal ~msg:"tl"
          (Right [2;3]) (Exceptionless.try_tl [1;2;3]);
        assert_equal ~msg:"failure"
          (Left (Failure "tl")) (Exceptionless.try_tl []));

    "try_nth" >::
      (fun () ->
        assert_equal ~msg:"nth"
          (Right 2) (Exceptionless.try_nth [1;2;3] 1);
        assert_equal ~msg:"failure"
          (Left (Invalid_argument "List.nth")) (Exceptionless.try_nth [1;2] ~-1))
    ]
