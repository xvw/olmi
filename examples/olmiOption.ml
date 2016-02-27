open Olmi

module Requirement = Make.WithBind(struct
    type 'a t = 'a option
    let return x = Some x
    let bind x f = match x with
      | Some v -> f v
      | None -> None
  end)

include Make.Monad(Requirement)
