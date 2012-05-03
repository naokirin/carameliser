module LazyMonad : Caramel_monad.S with type 'a t := 'a Lazy.t
