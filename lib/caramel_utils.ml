let (|>) x f = f x

let (<|) f x = f x

let (>>) f g x = g (f x)

let (<<) f g x = f (g x)

module State_monad = struct

  type ('a, 'b) state = 'a -> ('b * 'a)

  include Caramel_monad.Make2(struct
    type ('a, 'b) t = ('a, 'b) state

    let bind m f = fun s -> let a, s' = m s in f a s'

    let return x = fun s -> (x, s)
  end)

  let ( =<< ) f m = bind m f
  let ( >>> ) m x = m >>= fun _ -> x

  let get = fun s -> (s, s)
  let put s = fun _ -> ((), s)
  let run m s = m s
end


module Continuation_monad = struct
  type ('a, 'b) cont = ('b -> 'a) -> 'a

  include Caramel_monad.Make2(struct
      type ('a, 'b) t = ('a, 'b) cont

      let bind m f = fun k -> m (fun x -> f x k)
      let return x = fun k -> k x
  end)

  let callcc f = fun k -> f (fun a -> fun _ -> k a) k

  let id x = x
  let run m = m id

  let reset f = fun g -> g (f id)
  let shift f = fun g -> (f (fun x -> (fun h -> h (g x)))) id
end
