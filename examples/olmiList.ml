open Olmi

include List

module Requirement = Make.WithJoin(struct
    type 'a t = 'a list
    let return x = [x]
    let fmap = map
    let join = flatten
  end)

include Make.Plus (Requirement)
    (struct
      type 'a t = 'a list
      let mempty = []
      let mplus = append
    end)

