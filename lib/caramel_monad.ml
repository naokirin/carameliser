module Monad = struct
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
  end

  module Make(M:T) : S with type 'a t := 'a M.t = struct
    include M

    let bind = M.bind
    let return = return
    let map ~f x = bind x (fun n -> return (f n))
    let (>>=) = M.bind
    let (>>|) x f = map ~f x
  end
end
