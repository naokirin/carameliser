open OUnit

let _ =
  List.iter
    (fun test -> ignore(run_test_tt test))
    [Caramel_list_test.test]
