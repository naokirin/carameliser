open OUnit
open Caramel.String

let test =
  "Caramel_string" >::: [

    "hd" >:: (fun () ->
      assert_equal ~msg:"hd str equals to s"
          's' (hd "str");
      assert_equal ~msg:"hd a equals to a"
        'a' (hd "a");
      assert_raises ~msg:"hd empty raises Failure"
        (Failure "hd") (fun () -> hd ""));

    "tl" >:: (fun () ->
      assert_equal ~msg:"tl str equals to tr"
        "tr" (tl "str");
      assert_equal ~msg:"tl a equals to empty"
        "" (tl "a");
      assert_raises ~msg:"tl empty raises Failure"
        (Failure "tl") (fun () -> tl ""));
  ]
