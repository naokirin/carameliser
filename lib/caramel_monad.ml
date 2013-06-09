module type Infix = sig
  type 'a t

  val (>>=): 'a t -> ('a -> 'b t) -> 'b t
  val (>>|): 'a t -> ('a -> 'b) -> 'b t
end

(** Minimam Monad Type *)
module type T = sig
  type 'a t

  val bind: 'a t -> ('a -> 'b t) -> 'b t
  val return: 'a -> 'a t
end

module type S = sig
  type 'a t

  include Infix with type 'a t := 'a t
  include T with type 'a t := 'a t

  val map: f:('a -> 'b) -> 'a t -> 'b t
  val join: 'a t t -> 'a t
  val ignore: 'a t -> unit t
  val sequence : 'a t list -> 'a list t

  include Caramel_applicative.S with type 'a t := 'a t
end

module Make(M:T) : S with type 'a t := 'a M.t = struct
  include M

  let bind = M.bind
  let return = M.return
  let map ~f x = bind x (fun n -> return (f n))
  let join m = bind m (fun x -> x)
  let ignore t = map t ~f:(fun _ -> ())
  let rec sequence = function
    |[] -> return []
    |x::xs ->
      bind x (fun x ->
        (bind (sequence xs) (fun xs ->
          return (x::xs))))
  let (>>=) = bind
  let (>>|) x f = map ~f x


  let lift1 f x     = x >>= fun x -> return (f x)
  let lift2 f x y   = x >>= fun x -> lift1 (f x) y

  module Ap = Caramel_applicative.Make(struct
    type 'a t = 'a M.t

    let pure = return
    let (<*>) f x  = lift2 (fun f x -> f x) f x
  end)

  include Ap
end

(** 2 argument constructor *)
module type Infix2 = sig
  type ('a, 'b) t

  val (>>=): ('a, 'd) t -> ('d -> ('a, 'b) t) -> ('a, 'b) t
  val (>>|): ('a, 'd) t -> ('d -> 'b) -> ('a, 'b) t
end

(** Minimam Monad Type *)
module type T2 = sig
  type ('a, 'b) t

  val bind: ('a, 'd) t -> ('d -> ('a, 'b) t) -> ('a, 'b) t
  val return: 'a -> (_, 'a) t
end

module type S2 = sig
  type ('a, 'b) t

  include Infix2 with type ('a, 'b) t := ('a, 'b) t
  include T2 with type ('a, 'b) t := ('a, 'b) t

  val map: f:('d -> 'b) -> ('a, 'd) t -> ('a, 'b) t
  val join: ('a, ('a, 'b) t) t -> ('a, 'b) t
  val ignore: ('a, 'b) t -> ('a, unit) t
  val sequence : ('a, 'b) t list -> ('a, 'b list) t

  include Caramel_applicative.S2 with type ('a, 'b) t := ('a, 'b) t
end

module Make2(M:T2) : S2 with type ('a, 'b) t := ('a, 'b) M.t = struct
  include M

  let bind = M.bind
  let return = M.return
  let map ~f x = bind x (fun n -> return (f n))
  let join m = bind m (fun x -> x)
  let ignore t = map t ~f:(fun _ -> ())
  let rec sequence = function
    |[] -> return []
    |x::xs ->
      bind x (fun x ->
        (bind (sequence xs) (fun xs ->
          return (x::xs))))
  let (>>=) = bind
  let (>>|) x f = map ~f x


  let lift1 f x     = x >>= fun x -> return (f x)
  let lift2 f x y   = x >>= fun x -> lift1 (f x) y

  module Ap = Caramel_applicative.Make2(struct
    type ('a, 'b) t = ('a, 'b) M.t

    let pure = return
    let (<*>) f x  = lift2 (fun f x -> f x) f x
  end)

  include Ap
end
