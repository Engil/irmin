(*
 * Copyright (c) 2013-2015 Thomas Gazagnaire <thomas@gazagnaire.org>
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

(** Values. *)

module String: Ir_s.CONTENTS with type t = string and module Path = Ir_path.String_list
module Json: Ir_s.CONTENTS with type t = Ezjsonm.t and module Path = Ir_path.String_list
module Cstruct: Ir_s.CONTENTS with type t = Cstruct.t and module Path = Ir_path.String_list

module Make
    (S: sig
       include Ir_s.AO_STORE
       module Key: Ir_s.HASH with type t = key
       module Val: Ir_s.CONTENTS with type t = value
     end):
  Ir_s.CONTENTS_STORE
    with type t = S.t
      and type key = S.key
      and type value = S.value
      and module Path =  S.Val.Path
