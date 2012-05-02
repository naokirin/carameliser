module Option : sig

  (** [is_some] (or [is_none]) returns true if value is Some (or None) *)
  val is_some: 'a option -> bool
  val is_none: 'a option -> bool

  (** [value] take option value.  *)
  val value: 'a option -> default:'a -> 'a

  (** [ret_option] return to apply value to the function.
      Return None if raises Exception. *)
  val ret_option: f:('a -> 'b) -> 'a -> 'b option

  module MaybeMonad : Caramel_monad.Monad.S with type 'a t := 'a option
end
