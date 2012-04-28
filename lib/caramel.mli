module List : sig
  include module type of Caramel_list
end

val (@): 'a list -> 'a list -> 'a list
