open Olmi

module Requirement = Make.WithBind(
  struct
    type 'a t = 'a
    let return x = x
    let bind x f = f x
  end)

include Make.Monad(Requirement)
