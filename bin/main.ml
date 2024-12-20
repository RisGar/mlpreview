open Modules

let version = "0.0.1"

let match_mime mime file_name width height =
  let chan =
    match mime with
    (* directories *)
    | "inode/directory" -> Some Directory.directory
    (* archives *)
    | "application/x-tar"
    | "application/zip"
    | "application/x-zip-compressed"
    | "application/x-bzip"
    | "application/x-bzip2"
    | "application/gzip"
    | "application/x-gzip"
    | "application/x-xz"
    | "application/zstd"
    | "application/x-lzip" -> Some (Archive.archive file_name)
    (* quicklook: pdfs *)
    | "application/pdf" -> Some (Image.ql file_name ~width ~height)
    (* binary *)
    | "application/octet-stream" -> Some (Binary.binary file_name)
    (* empty files *)
    | "inode/x-empty" ->
      print_endline "Empty file";
      None
    (* text *)
    | "text/plain" | "application/json" -> Some (Text.text file_name)
    (* images *)
    | str when String.starts_with ~prefix:"image" str ->
      Some (Image.image file_name ~width ~height)
    (* quicklook: videos *)
    | str when String.starts_with ~prefix:"video" str ->
      Some (Image.ql file_name ~width ~height)
    (* everything else *)
    | _ ->
      print_endline mime;
      Some (Text.text file_name)
  in
  match chan with
  | Some chan -> Helpers.print_in_stream chan
  | None -> ()
;;

let dims_or_default str num =
  match str with
  | Some x -> int_of_string x
  | None -> num
;;

let match_special_args = function
  | "-h" | "--help" ->
    print_endline "Usage: mlpreview [OPTION]... [FILE] [WIDTH] [HEIGHT]";
    print_endline "Preview files in the terminal.";
    print_endline "";
    print_endline "Options:";
    print_endline "  -h, --help       display this help and exit";
    print_endline "  -v, --version    output version information and exit";
    print_endline "";
    print_endline "When no FILE is provided current directory is read.";
    exit 0
  | "-v" | "--version" ->
    print_endline @@ "mlpreview " ^ version;
    print_endline
    @@ "Copyright (C) "
    ^ (string_of_int @@ (1900 + (Unix.gmtime @@ Unix.time ()).tm_year))
    ^ " Rishab Garg";
    print_endline "Licensed under the EUPL-1.2";
    exit 0
  | _ -> ()
;;

let handle_file args =
  let file_name = List.nth args 1 in
  let width = dims_or_default (List.nth_opt args 2) 160 - 1 in
  let height = dims_or_default (List.nth_opt args 3) 40 - 1 in
  let mime = Helpers.get_mime file_name in
  match_mime mime file_name width height
;;

let () =
  let args = Sys.argv |> Array.to_list in
  (* print directory when no arguments supplied *)
  if List.length args <= 1
  then (
    Helpers.print_in_stream Directory.directory;
    exit 0);
  (* handle help and version options *)
  match_special_args @@ List.nth args 1;
  (* handle files *)
  if not @@ Sys.file_exists @@ List.nth args 1
  then failwith "ERROR: File does not exist."
  else handle_file args
;;
