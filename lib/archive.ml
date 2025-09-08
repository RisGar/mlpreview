open Archive_bindings.C.Functions
open Archive_bindings.C.Types
open Ctypes
open Helpers

let humanise_size size =
  let units = [| "B"; "KB"; "MB"; "GB"; "TB"; "PB"; "EB"; "ZB"; "YB" |] in
  let rec humanise_size' size unit_index =
    if size < 1024.0 || unit_index = Array.length units - 1 then
      Printf.sprintf "%.1f %s" size units.(unit_index)
    else humanise_size' (size /. 1024.0) (unit_index + 1)
  in
  humanise_size' (float_of_int size) 0

let humanise_time timestamp =
  let tm = Unix.gmtime timestamp in
  Printf.sprintf "%02d/%02d/%04d %02d:%02d" tm.tm_mday (tm.tm_mon + 1)
    (tm.tm_year + 1900) tm.tm_hour tm.tm_min

(* repeat string n times *)
let rec repeat (str : string) (n : int) =
  match n with 0 -> str | _ -> str ^ repeat str (n - 1)

(* monadic-style "bind" on error_code *)
let ( >>= ) a b =
  match a with
  | ARCHIVE_OK -> b ()
  | n ->
      prerr_endline @@ "error: libarchive returned " ^ string_of_error_code n
      ^ ".";
      exit 1

let generate_text file_name =
  (* allocate / get back structs *)
  let archive = archive_read_new () in
  let archive_entry =
    allocate (ptr archive_entry) (from_voidp archive_entry null)
  in

  (* enable all formats and filters, then open *)
  archive_read_support_filter_all archive >>= fun () ->
  archive_read_support_format_all archive >>= fun () ->
  archive_read_open_filename archive file_name (Unsigned.Size_t.of_int 10240)
  >>= fun () ->
  ();

  (* list refs to read info into *)
  let strmodes = ref [] in
  let names = ref [] in
  let sizes = ref [] in
  let mtimes = ref [] in

  (* read from archive *)
  while archive_read_next_header archive archive_entry = ARCHIVE_OK do
    let entry = !@archive_entry in
    strmodes := archive_entry_strmode entry :: !strmodes;
    names := archive_entry_pathname_utf8 entry :: !names;
    sizes := archive_entry_size entry :: !sizes;
    mtimes := PosixTypes.Time.to_int64 (archive_entry_mtime entry) :: !mtimes
  done;

  (* convert size to humanly readable *)
  let human_sizes =
    List.mapi
      (fun i size ->
        if List.nth !strmodes i |> String.starts_with ~prefix:"d" then "-"
        else humanise_size @@ Int64.to_int size)
      !sizes
  in
  let human_dates =
    List.map (fun t -> humanise_time @@ Int64.to_float t) !mtimes
  in
  let max_size =
    List.fold_left (fun acc str -> max acc (String.length str)) 0 human_sizes
  in

  (* TODO: terminal colours *)
  let res =
    List.init (List.length !strmodes) (fun i ->
        let size = List.nth human_sizes i in
        let strmode = List.nth !strmodes i in
        let mtime = List.nth human_dates i in
        let name = List.nth !names i in
        strmode ^ " "
        ^ repeat " " (max_size - String.length size)
        ^ size ^ " " ^ mtime ^ " " ^ name)
    |> String.concat "\n"
  in

  archive_read_free archive >>= fun () -> res

let generate_cache cache_file text =
  Out_channel.with_open_text cache_file
    (Fun.flip Out_channel.output_string text)

let archive file_name =
  let cache_file = Helpers.get_cache_file file_name `TEXT in
  if not @@ Sys.file_exists cache_file then
    generate_cache cache_file (generate_text file_name);
  In_channel.with_open_text cache_file (print_endline << In_channel.input_all)
