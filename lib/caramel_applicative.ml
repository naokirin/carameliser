module type T = sig
  type 'a t

  val pure : 'a -> 'a t
  val (<*>) : ('a -> 'b) t -> 'a t -> 'b t
end

module type S = sig
  type 'a t

  include T with type 'a t := 'a t

  val lift1 : f:('a -> 'b) -> 'a t -> 'b t
  val lift2 : f:('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
  val lift3 : f:('a -> 'b -> 'c -> 'd) -> 'a t -> 'b t -> 'c t -> 'd t
  val liftM : ('a -> 'b) t -> 'a t -> 'b t

  val (<$>) : ('a -> 'b) -> 'a t -> 'b t

  val sequence : 'a t list -> 'a list t
  val map_a : f:('a -> 'b t) -> 'a list -> 'b list t

  val (<*) : 'a t -> 'a t -> 'a t
  val (>*) : 'a t -> 'a t -> 'a t
end

module Make(A:T) : S with type 'a t := 'a A.t = struct
  include A

  let pure = A.pure
  let (<*>) = A.(<*>)

  let lift1 ~f x = pure f <*> x
  let lift2 ~f x y = lift1 ~f x <*> y
  let lift3 ~f x y z = lift2 ~f x y <*> z
  let liftM = (<*>)

  let (<$>) f x = lift1 ~f x

  let (<*) x y = lift2 ~f:(fun x _ -> x) x y
  let (>*) x y = lift2 ~f:(fun _ y -> y) x y

  let sequence s = List.fold_left (lift2 ~f:(fun xs x -> x::xs))
    (pure []) s

  let map_a ~f xs = sequence (List.map f xs)
end

module type T2 = sig
  type ('a, 'b) t

  val pure : 'a -> (_, 'a) t
  val (<*>) : ('a, 'b -> 'c) t -> ('a, 'b) t -> ('a, 'c) t
end

module type S2 = sig
  type ('a, 'b) t

  include T2 with type ('a, 'b) t := ('a, 'b) t

  val lift1 : f:('a -> 'b) -> ('c, 'a) t -> ('c, 'b) t
  val lift2 : f:('a -> 'b -> 'c) -> ('d, 'a) t -> ('d, 'b) t -> ('d, 'c) t
  val lift3 : f:('a -> 'b -> 'c -> 'd) -> ('e, 'a) t -> ('e, 'b) t ->
    ('e, 'c) t -> ('e, 'd) t
  val liftM : ('a, 'b -> 'c) t -> ('a, 'b) t -> ('a, 'c) t
  val (<$>) : ('a -> 'b) -> ('c, 'a) t -> ('c, 'b) t

  val sequence : ('a, 'b) t list -> ('a, 'b list) t
  val map_a : f:('a -> ('b, 'c) t) -> 'a list -> ('b, 'c list) t

  val (<*) : ('a, 'b) t -> ('a, 'c) t -> ('a, 'b) t
  val (>*) : ('a, 'b) t -> ('a, 'c) t -> ('a, 'c) t
end

module Make2(A:T2) : S2 with type ('a, 'b) t := ('a, 'b) A.t = struct
  include A

  let pure = A.pure
  let (<*>) = A.(<*>)

  let lift1 ~f x = pure f <*> x
  let lift2 ~f x y = lift1 ~f x <*> y
  let lift3 ~f x y z = lift2 ~f x y <*> z
  let liftM = (<*>)

  let (<$>) f x = lift1 ~f x

  let (<*) x y = lift2 ~f:(fun x _ -> x) x y
  let (>*) x y = lift2 ~f:(fun _ y -> y) x y

  let sequence s = List.fold_left (lift2 ~f:(fun xs x -> x::xs))
    (pure []) s

  let map_a ~f xs = sequence (List.map f xs)
end
