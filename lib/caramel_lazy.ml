module LazyMonad = Caramel_monad.Make(struct
  type 'a t = 'a Lazy.t
  let return x = lazy x
  let bind m f = f (Lazy.force m)
end)
