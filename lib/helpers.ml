let print_in_stream stream = stream |> In_channel.input_all |> print_endline

let get_mime file_name =
  Printf.sprintf "file -b --mime-type \"%s\"" file_name
  |> Unix.open_process_in
  |> In_channel.input_all
  |> String.trim
;;

let cache_dir =
  let cache_dir' =
    match Sys.getenv_opt "XDG_CACHE_HOME" with
    | Some x -> x ^ "/mlpreview/"
    | None -> Sys.getenv "HOME" ^ "/.cache/mlpreview/"
  in
  (* create cache dir if it doesn't exist *)
  if not @@ Sys.file_exists cache_dir' then Sys.mkdir cache_dir' 0o755;
  cache_dir'
;;

type cache_type =
  | THUMB
  | ARCHIVE

let get_cache_file file_name cache_t =
  let hash = Digest.MD5.file file_name |> Digest.to_hex in
  cache_dir
  ^
  match cache_t with
  | THUMB -> "ql-" ^ hash ^ ".png"
  | ARCHIVE -> "la-" ^ hash ^ ".txt"
;;
