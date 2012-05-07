
type 'a t = 'a option

(** [is_some] (or [is_none]) returns true if value is Some (or None) *)
val is_some: 'a t -> bool
val is_none: 'a t -> bool

(** [value] take option value.  *)
val value: 'a t -> default:'a -> 'a

(** [ret_option] return to apply value to the function.
    Return None if raises Exception. *)
val ret_option: f:('a -> 'b) -> 'a -> 'b t

module MaybeMonad : Caramel_monad.S with type 'a t := 'a t
