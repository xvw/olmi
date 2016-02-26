(*
 * Olmi
 *
 * Copyright (C) 2015  Xavier Van de Woestyne <xaviervdw@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
*)

open OlmiInterfaces

let id x = x
let flip f x y = f y x

(* Functors for monad implementation *)
(* Using join interface *)
module WithJoin (M : JOIN) : BASIC_INTERFACE with type 'a t = 'a M.t =
struct
  include M
  let bind m f = join (fmap f m)
end


(* Using bind interface *)
module WithBind (M : BIND) : BASIC_INTERFACE with type 'a t = 'a M.t =
struct
  include M
  let join m = bind m id
  let fmap f m = bind m (fun x -> return (f x))
end

(* Functor for creating a complete monad *)
module Monad (M : BASIC_INTERFACE) : INTERFACE with type 'a t = 'a M.t =
struct

  include M

  let ( >>= ) = bind
  let ( >|= ) x f = fmap f x
  let ( >> ) m n = m >>= (fun _ -> n)

  let ( <=< ) f g = fun x -> g x >>= f
  let ( >=> ) f g = flip ( <=< ) f g
  let ( =<< ) f x = flip ( >>= ) f x

  let ( <*> ) fs ms =
    fs >>= fun f ->
    ms >>= fun x -> return (f x)

  let ( *> ) x = ( <*> ) (fmap (fun _ -> id) x)
  let ( <* ) x _ = ( <*> ) (return (fun x -> x)) x
  let ( <**> ) f x = flip ( <*> ) f x

  let ( <$> ) = fmap
  let ( <$ ) v = fmap (fun _ -> v)

  let liftM = fmap

  let liftM2 f m1 m2 =
    m1 >>= fun x ->
    m2 >>= fun y -> return (f x y)

  let liftM3 f m1 m2 m3 =
    m1 >>= fun x ->
    m2 >>= fun y ->
    m3 >>= fun z -> return (f x y z)

  let liftM4 f m1 m2 m3 m4 =
    m1 >>= fun x ->
    m2 >>= fun y ->
    m3 >>= fun z ->
    m4 >>= fun a -> return (f x y z a)

  let liftM5 f m1 m2 m3 m4 m5 =
    m1 >>= fun x ->
    m2 >>= fun y ->
    m3 >>= fun z ->
    m4 >>= fun a ->
    m5 >>= fun b -> return (f x y z a b)

  let void _ = return ()


end
