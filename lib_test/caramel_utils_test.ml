open OUnit
open Caramel.Utils

let test =
  "Caramel_Utils" >:::
  [
    "|>" >::
      (fun () ->
        assert_equal ~msg:"arg 1" (1 |> (fun i -> i)) 1;
        assert_equal ~msg:"arg 2" (1 |> (fun i x -> i+x) 2) 3);

    "<|" >::
      (fun () ->
        assert_equal ~msg:"arg 1" ((fun i -> i) <| 1) 1;
        assert_equal ~msg:"arg 2" (((fun i x -> i+x) 2) <| 1) 3);

    ">>" >::
      (fun () ->
        assert_equal ~msg:"composition"
          (((fun i -> i+1) >> (fun i -> i*2)) 2) 6);

    "<<" >::
      (fun () ->
        assert_equal ~msg:"rev comp"
          (((fun i -> i+1) << (fun i -> i*2)) 2) 5)
  ]
