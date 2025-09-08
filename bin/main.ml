open Modules

let handle_filetype ~filename ~width ~height = function
  (* empty files *)
  | "inode/x-empty" -> print_endline "Empty file"
  (* directories *)
  | "inode/directory" -> Directory.directory ()
  (* archives *)
  | "application/x-tar" | "application/zip" | "application/x-zip-compressed"
  | "application/x-bzip" | "application/x-bzip2" | "application/gzip"
  | "application/x-gzip" | "application/x-xz" | "application/zstd"
  | "application/x-lzip" ->
      Archive.archive filename
  (* pdfs *)
  | "application/pdf" -> Pdf.pdf filename ~width ~height
  (* binary *)
  | "application/octet-stream" -> Binary.binary filename
  (* text *)
  | "text/plain" | "application/json" -> Text.text filename
  (* images *)
  | str when String.starts_with ~prefix:"image" str ->
      Image.image filename ~width ~height
  (* videos *)
  | str when String.starts_with ~prefix:"video" str ->
      FFmpeg.thumbnail filename ~width ~height
  (* everything else, print mime to find new possible filetypes to handle *)
  | mime ->
      print_endline mime;
      Text.text filename

let mlpreview ~width ~height ~horizontal ~vertical = function
  | None -> `Ok (Directory.directory ())
  | Some filename ->
      ignore horizontal;
      ignore vertical;
      if not @@ Sys.file_exists @@ filename then
        `Error (false, "file does not exist.")
      else
        `Ok
          (Helpers.get_mime filename |> handle_filetype ~filename ~width ~height)

open Cmdliner
open Cmdliner.Term.Syntax

let filename =
  let doc = "File to preview." in
  Arg.(value & pos 0 (some file) None & info [] ~docv:"FILE" ~doc)

let width =
  let doc = "Width of preview for images." in
  Arg.(value & pos 1 int 150 & info [] ~docv:"WIDTH" ~doc)

let height =
  let doc = "Height of preview for images." in
  Arg.(value & pos 2 int 30 & info [] ~docv:"HEIGHT" ~doc)

let horizontal =
  let doc = "Horizontal position (currently unused)." in
  Arg.(value & pos 3 int 0 & info [] ~docv:"HPOS" ~doc)

let vertical =
  let doc = "Vertical position (currently unused)." in
  Arg.(value & pos 4 int 0 & info [] ~docv:"VPOS" ~doc)

let mlpreview_cmd =
  let doc = "Preview files in the terminal." in
  let man =
    [
      `S Manpage.s_description;
      `P
        "Allows previewing of different filetypes in the terminal, for example \
         with lf.";
      `S Manpage.s_bugs;
      `P "Create an issue at <https://github.com/RisGar/mlpreview/issues/new>.";
      `S "COPYRIGHT";
      `P
        ("Copyright (C) "
        ^ (string_of_int @@ (1900 + (Unix.gmtime @@ Unix.time ()).tm_year))
        ^ " Rishab Garg");
      `P "Licensed under the EUPL-1.2";
    ]
  in
  Cmd.v (Cmd.info "mlpreview" ~version:"%%VERSION%%" ~doc ~man)
  @@ Term.ret
  @@
  let+ filename = filename
  and+ width = width
  and+ height = height
  and+ horizontal = horizontal
  and+ vertical = vertical in
  mlpreview ~width ~height ~horizontal ~vertical filename

let main () = Cmd.eval mlpreview_cmd
let () = if !Sys.interactive then () else exit (main ())
