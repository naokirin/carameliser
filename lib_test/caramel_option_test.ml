open OUnit
open Caramel.Option

let test =
  "Caramel_list" >:::
  [
    "value" >::
      (fun () ->
        assert_equal ~msg:"Some"
          1 (value (Some 1) ~default:0);
        assert_equal ~msg:"None"
          0 (value (None) ~default:0));

    "ret_option" >::
      (fun () ->
        assert_equal ~msg:"Some"
          (Some 0) (ret_option 0 ~f:(fun x -> x));
        assert_equal ~msg:"None"
          None (ret_option 0 ~f:(fun x -> if x=0 then invalid_arg "x" else x)));
  ]
