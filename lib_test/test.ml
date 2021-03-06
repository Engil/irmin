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

let misc = [
  Test_git.misc;
  Test_link.misc;
]

let suite k =
  let depends = if k = `String then `Quick else `Slow in
  [
    `Quick , Test_memory.suite k;
    `Quick , Test_fs.suite k;
    `Quick , Test_git.suite k;
    depends, Test_http.suite ~content_type:`Raw (Test_memory.suite k);
    depends, Test_http.suite ~content_type:`Json (Test_memory.suite k);
    `Slow  , Test_http.suite ~content_type:`Raw (Test_fs.suite k);
    `Slow  , Test_http.suite ~content_type:`Json (Test_fs.suite k);
    `Slow  , Test_http.suite ~content_type:`Raw (Test_git.suite k);
    `Slow  , Test_http.suite ~content_type:`Json (Test_git.suite k);
  ]

let () =
  Test_store.run "irmin" ~misc (suite `String @ suite `Json)
