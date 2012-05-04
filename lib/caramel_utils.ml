let (|>) x f = f x

let (<|) f x = f x

let (>>) f g x = g (f x)

let (<<) f g x = f (g x)
