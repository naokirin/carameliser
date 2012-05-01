module Monad : sig
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

  module Make : functor (M : T) -> sig
    val ( >>= ) : 'a M.t -> ('a -> 'b M.t) -> 'b M.t
    val ( >>| ) : 'a M.t -> ('a -> 'b) -> 'b M.t
    val bind : 'a M.t -> ('a -> 'b M.t) -> 'b M.t
    val return : 'a -> 'a M.t
    val map: f:('a -> 'b) -> 'a M.t -> 'b M.t
    val join: 'a M.t M.t -> 'a M.t
    val ignore: 'a M.t -> unit M.t
  end
end
