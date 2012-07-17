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
end



















