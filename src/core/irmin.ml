(*
 * Copyright (c) 2013 Thomas Gazagnaire <thomas@gazagnaire.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

module type S = sig
  type t
  type path
  include IrminStore.M with type key := path
  val snapshot: unit -> t Lwt.t
  val revert: t -> unit Lwt.t
  val watch: path -> (path * t option) Lwt_stream.t
end

module type STORE = sig
  type key
  type value
  type tag
  module Value: IrminValue.STORE
    with type key = key
     and type t = value
  module Tree: IrminTree.STORE
    with type key = key
     and type value = value
  module Revision: IrminRevision.STORE
    with type key = key
     and type tree = Tree.t
  module Tag: IrminTag.STORE
    with type t = tag
     and type key = key
  module type S = S with type t = Revision.t
                     and type path = Tree.path
  val master: unit -> (module S)
  val create: Tag.t -> (module S)
end

module Make
    (Key: IrminKey.S)
    (Value: IrminValue.S)
    (Tag: IrminTag.S)
    (SValue: IrminStore.IRAW with type key = Key.t)
    (STree: IrminStore.IRAW with type key = Key.t)
    (SRevision: IrminStore.IRAW with type key = Key.t)
    (STag: IrminStore.MRAW with type value = Key.t) =
struct

  open Lwt

  module Value = IrminValue.Make(SValue)(Key)(Value)
  module Tree = IrminTree.Make(STree)(Key)(Value)
  module Revision = IrminRevision.Make(SRevision)(Key)(Tree)
  module Tag = IrminTag.Make(STag)(Tag)(Key)

  type key = Key.t
  type value = Value.t
  type tree = Tree.t
  type revision = Revision.t
  type path = Tree.path
  type tag = Tag.t
  module type S = S with type t = Revision.t
                     and type path = Tree.path

  module S (T: sig val tag: Tag.t end) = struct

    type t = revision

    let init () =
      Value.init () >>= fun () ->
      Tree.init () >>= fun () ->
      Revision.init () >>= fun () ->
      Tag.init ()

    let set t path value =
      match Revision.tree t with
      | None      -> failwith "TODO"
      | Some tree ->
        tree >>= fun tree ->
        Tree.add tree path value >>= fun tree ->
        Revision.with_tree t (Some tree)

    let remove _ = failwith "TODO"

    let read _ = failwith "TODO"

    let read_exn _ = failwith "TODO"

    let mem _ = failwith "TODO"

    let list _ = failwith "TODO"

    let snapshot _ = failwith "TODO"

    let revert _ = failwith "TODO"

  end

  let master _ = failwith "TODO"

  let create _ = failwith "TODO"

end

module Simple = struct

  module Key = IrminKey.SHA1
  module Value = IrminValue.Simple
  module Tag = IrminTag.Simple
  module Make
      (I: IrminStore.IRAW with type key = Key.t)
      (M: IrminStore.MRAW with type value = Key.t)
    = Make(Key)(Value)(Tag)(I)(I)(I)(M)

end