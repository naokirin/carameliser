type 'a t = 'a lazy_t

module Lazy_monad = Caramel_monad.Make(struct
  type 'a t = 'a lazy_t
  let return x = lazy x
  let bind m f = f (Lazy.force m)
end)

exception Undefined
let force = Lazy.force
let force_val = Lazy.force_val
let lazy_from_fun = Lazy.lazy_from_fun
let lazy_from_val = Lazy.lazy_from_val
let lazy_is_val = Lazy.lazy_is_val










