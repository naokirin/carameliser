open OUnit
open Caramel.Utils

let increment =
  State_monad.(get >>= fun s ->
    let value = s in
    let s' = s + 1 in
    put s' >>> return value)

type 'a cons_list = Nils | Cons of 'a * 'a cons_list

let cons s lst =
  State_monad.(get >>= fun i ->
               let i' = i + 1 in
               put i' >>= (fun x -> return (Cons (s, lst))))

let test =
  "Caramel.Utils" >::: [
    "|>" >:: (fun () ->
        assert_equal ~msg:"arg 1" (1 |> (fun i -> i)) 1;
        assert_equal ~msg:"arg 2" (1 |> (fun i x -> i+x) 2) 3);

    "<|" >:: (fun () ->
        assert_equal ~msg:"arg 1" ((fun i -> i) <| 1) 1;
        assert_equal ~msg:"arg 2" (((fun i x -> i+x) 2) <| 1) 3);

    ">>" >:: (fun () ->
        assert_equal ~msg:"composition"
          (((fun i -> i+1) >> (fun i -> i*2)) 2) 6);

    "<<" >:: (fun () ->
        assert_equal ~msg:"rev comp"
          (((fun i -> i+1) << (fun i -> i*2)) 2) 5);

    "Caramel.Utils.State_monad" >::: [
      "increment with int" >:: (fun () ->
        assert_equal ~msg:"incremented 1 is 2"
           (1, 2) (State_monad.(get >>= fun s -> increment >>> return s) 1);
        assert_equal ~msg:"increment at twice"
          (2, 4) (State_monad.(get >>= fun s -> increment >>> increment >>> return s) 2);
        assert_equal ~msg:"put and increment at once"
          (1, 3) (State_monad.(get >>= fun s -> put (s+1) >>> increment >>> return s) 1));

      "List with counter" >:: (fun () ->
        assert_equal ~msg:"counter 1"
          (Cons ("a", Nils), 1) (State_monad.((fun s -> return s) =<< cons "a" Nils) 0);
        assert_equal ~msg:"counter 2"
          (Cons ("b", Cons ("a", Nils)), 2) (State_monad.((fun s -> return s) =<< (cons "b" =<< cons "a" Nils)) 0))
    ]
  ]
