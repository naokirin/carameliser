open OUnit
open Caramel.List

let test =
  "Caramel_list" >:::
  [
    "split_nth" >::
      (fun () ->
        "split_0th" @? ((=) ([], [1;2;3]) (split_nth 0 [1;2;3]));
        "split_1st" @? ((=) ([1], [2;3]) (split_nth 1 [1;2;3]));
        "over" @? ((=) ([1;2;3], []) (split_nth 3 [1;2;3]));
        "empty" @? ((=) ([], []) (split_nth 0 []));
        "minus" @? ((=) ([], [1;2;3]) (split_nth ~-1 [1;2;3])));

    "split_while" >::
      (fun () ->
        "split_1" @?
          ((=) ([], [1; 2; 3]) (split_while [1; 2; 3] ~f:(fun n -> n<1)));
        "split_2" @?
          ((=) ([1], [2; 3]) (split_while [1; 2; 3] ~f:(fun n -> n<2)));
        "over" @?
          ((=) ([1;2;3], []) (split_while [1;2;3] ~f:(fun n -> n<4)));
        "empty" @?
          ((=) ([], []) (split_while [] ~f:(fun n -> n=0))));

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
        "list" @? ((=) 1 !result));

    "collect" >::
      (fun () ->
        "plus_1" @?
          ((=) [1; 2; 3] (collect [0; 1; 2] ~f:(fun i -> [i+1])));
        "empty" @?
          ((=) [] (collect [] ~f:(fun i -> [i])));
        "length 1" @?
          ((=) [1] (collect [0] ~f:(fun i -> [i+1]))));

    "filter_map" >::
      (fun () ->
        "greater than 3" @?
          ((=) [4; 5; 6] (filter_map [1; 2; 3; 4; 5; 6]
            ~f:(fun x ->(if (x>3) then (Some x) else None)))));

    "mapi" >::
      (fun () ->
        "index + data" @?
          ((=) [1; 2; 3; 4] (mapi [1; 1; 1; 1] ~f:(fun i x -> i+x)));
        "'index' ^ 'data'" @?
          ((=) ["0a"; "1b"; "2c"] (mapi ["a"; "b"; "c"] ~f:(fun i x -> (string_of_int i) ^ x))));

    "try_find" >::
      (fun () ->
        "found" @?
          ((=) (Some 2) (try_find [1; 2; 3] ~f:(fun n -> n=2)));
        "not found" @?
          ((=) None (try_find [1; 2; 3] ~f:(fun n -> n=5))));

    "findi" >::
      (fun () ->
        "found" @?
          ((=) (1, 2) (findi [1; 2; 3] ~f:(fun i n -> n=2 && i=1)));
        assert_raises ~msg:"not found"
          (Not_found) (fun () -> findi [1; 2; 3] ~f:(fun i n -> n=5)));

    "rfind" >::
      (fun () ->
        "found" @?
          ((=) 4 (rfind [1; 2; 3; 4; 5] ~f:(fun n -> (n mod 2)=0)));
        assert_raises ~msg:"not found"
          (Not_found) (fun () -> rfind [1; 2; 3] ~f:(fun n -> n=5)));

    "reduce" >::
      (fun () ->
        "add 1..5" @?
          ((=) 15 (reduce [1; 2; 3; 4; 5] ~f:(+)));
        "concat string" @?
          ((=) "abcd" (reduce ["a"; "b"; "c"; "d"] ~f:(^)));
        assert_raises ~msg:"list should not be empty"
          (Invalid_argument "The list is empty.") (fun () -> reduce [] ~f:(+)));

    "try_reduce" >::
      (fun () ->
        "add 1..5" @?
          ((=) (Some 15) (try_reduce [1; 2; 3; 4; 5] ~f:(+)));
        "concat string" @?
          ((=) (Some "abcd") (try_reduce ["a"; "b"; "c"; "d"] ~f:(^)));
        "empty" @?
          ((=) None (try_reduce [] ~f:(+))));

    "unique" >::
      (fun () ->
        "[1; 1]" @?
          ((=) [1] (unique [1; 1]));
        "[1;2;3;1;2;3]" @?
          ((=) [1; 2; 3] (unique [1;2;3;1;2;3])));

    "drop" >::
      (fun () ->
        "drop1" @?
          ((=) [2;3] (drop 1 [1; 2; 3]));
        "drop2" @?
          ((=) [] (drop 4 [1; 2; 3])));

    "drop_while" >::
      (fun () ->
        "drop_while1" @?
          ((=) [4;5] (drop_while [1;2;3;4;5] ~f:(fun n -> n<4)));
        "empty" @?
          ((=) [] (drop_while [] ~f:(fun n -> true))));

    "remove" >::
      (fun () ->
        "remove" @?
          ((=) [1; 3] (remove 2 [1; 2; 3]));
        "remove nothing" @?
          ((=) [1; 2; 3] (remove 4 [1; 2; 3]));
        "empty" @?
          ((=) [] (remove 1 [])));

    "remove_all" >::
      (fun () ->
        "remove_all" @?
          ((=) [1] (remove_all 2 [2; 1; 2]));
        "remove nothing" @?
          ((=) [1; 2; 3] (remove_all 4 [1; 2; 3]));
        "empty" @?
          ((=) [] (remove_all 1 [])));

    "take" >::
      (fun () ->
        "take 1" @?
          ((=) [1] (take 1 [1;2;3]));
        "take 0" @?
          ((=) [] (take 0 [1;2;3]));
        "empty" @?
          ((=) [] (take 1 []));
        "minus" @?
          ((=) [] (take ~-1 [1;2;3])));

    "take_while" >::
      (fun () ->
        "take_while n<3" @?
          ((=) [1;2] (take_while [1;2;3] ~f:(fun n -> n<3)));
        "empty" @?
          ((=) [] (take_while [] ~f:(fun n -> true))));

    "init" >::
      (fun () ->
        "init 1" @?
          ((=) [1] (init 1 ~f:(fun n -> 1)));
        "init 2" @?
          ((=) [1;2;3] (init 3 ~f:(fun n -> n+1)));
        "empty" @?
          ((=) [] (init 0 ~f:(fun n -> 1)));
        "minus" @?
          ((=) [] (init ~-1 ~f:(fun n -> 1))));

    "make" >::
      (fun () ->
        "make 1" @?
          ((=) [1] (make 1 1));
        "make 2" @?
          ((=) [1;1;1] (make 3 1));
        "empty" @?
          ((=) [] (make 0 0));
        "minus" @?
          ((=) [] (make ~-1 0)));

    "of_array" >::
      (fun () ->
        "[|1; 2; 3|]" @?
          ((=) [1; 2; 3] (of_array [|1; 2; 3|])));

    "to_array" >::
      (fun () ->
        "[1; 2; 3]" @?
          ((=) [|1; 2; 3|] (to_array [1; 2; 3])))
    ]
