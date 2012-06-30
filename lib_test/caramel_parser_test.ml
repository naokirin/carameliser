open OUnit
open Caramel.Parser
open Caramel.Parser.String_parser

let test =
  "Caramel_parser.String_parser" >::: [
    "parse a charactor" >:: (fun () ->
      assert_equal ~msg:"parse a"
        (Some "a") (parse (is "a") (stream_of_string "abc")));

    "parse a number" >:: (fun () ->
      assert_equal ~msg:"parse 1"
        (Some "1") (parse number (stream_of_string "123")));

    "parse letters" >:: (fun () ->
      assert_equal ~msg:"parse abc"
        (Some "abc") (parse letters (stream_of_string "abc")));

    "parse many letters or/and numbers" >:: (fun () ->
      assert_equal ~msg:"parse abc 123 def"
        (Some ["abc"; "123"; "def"]) (parse (many1 (letters <|> numbers)) (stream_of_string "abc123def")));

    "parse removing spaces" >:: (fun () ->
      assert_equal ~msg:"parse removing spaces"
        (Some "abc") (parse (spaces >>+ letters) (stream_of_string "   abc"));
      assert_equal ~msg:"parse many strings with removing spaces"
        (Some ["def"; "abc"]) (parse (many1 ((spaces >>+ letters <|> letters) +>> spaces)) (stream_of_string "  def   abc  ")));

    "parse char" >:: (fun () ->
      assert_equal ~msg:"parse the secound charactor"
        (Some "b") (parse (letter >>* letter) (stream_of_string "abcd")));

    "parse combinating string" >:: (fun () ->
      assert_equal ~msg:"parse the secound charactor"
        (Some "ab   1234") (parse (letters &>> spaces &>> numbers) (stream_of_string "ab   1234 abc")));
  ]


(* ** using pa_monad **

let p = perform with module Caramel.Parser in
  a <-- String_parser.number;
  String_parser.space;
  b <-- String_parser.number;
  Caramel.Parser.return (a^b) in
  parse p (stream_of_string "1 0")
*)




