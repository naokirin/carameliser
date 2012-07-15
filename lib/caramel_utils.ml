let (|>) x f = f x

let (<|) f x = f x

let (>>) f g x = g (f x)

let (<<) f g x = f (g x)

module State_monad = struct

  type ('a, 'b) state = State of ('a -> ('b * 'a))

  let value = function State x -> x

  include Caramel_monad.Make2(struct
    type ('a, 'b) t = ('a, 'b) state

    let bind m f = State (fun s -> let a, s' = (value m) s in ((value (f a)) s'))

    let return x = State (fun s -> (x, s))
  end)

  let ( =<< ) f m = bind m f
  let ( >>> ) m x = m >>= (fun _ -> x)

  let get = State (fun s -> (s, s))
  let put s = State (fun _ -> ((), s))

  let run m a = (value m) a
end



















