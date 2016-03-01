# OLMI 
> OCaml lightweight monad interface

OLMI provide just functors to build monadics combinators. The library provide two 
way for creating monads : 

-  With Bind as a minimal interface 
-  With Fmap and Join as a minimal interface 

## Exposed functors 

-  `Make.WithBind(M : Interfaces.BIND) : Interfaces.BASIC_INTERFACE`
-  `Make.WithJoin(M : Interfaces.JOIN) : Interfaces.BASIC_INTERFACE`
-  `Make.Monad(M : Interfaces.BASIC_INTERFACE) : Interfaces.INTERFACE`
-  `Make.Plus(M : Interfaces.BASIC_INTERFACE) (Interfaces.PLUS_INTERFACE)`

See `lib/olmiInterfaces.ml` for the generated API
 
## Example

Implement identity Monad 

```ocaml
open Olmi 

module Requirement = Make.WithBind(
  struct
    type 'a t = 'a
    let return x = x
    let bind x f = f x
  end)

include Make.Monad(Requirement)

```

Implement Non-determinist monad 

```ocaml
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

```

## Use ./toplevel.sh 
After `make`, you can use `./toplevel.sh` for running a REPL with OlmiExamples loaded. 
In this REPL, you have : 

-  OlmiExamples.List
-  OlmiExamples.Identity
-  OlmiExamples.Option


