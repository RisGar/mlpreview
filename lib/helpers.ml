let ( << ) f g = Fun.compose f g

let get_mime file_name =
  let channel =
    Unix.open_process_in
    @@ Printf.sprintf "file -b --mime-type \"%s\"" file_name
  in

  let res = String.trim @@ In_channel.input_all @@ channel in
  In_channel.close channel;
  res

let cache_dir =
  let dirpath =
    match Sys.getenv_opt "XDG_CACHE_HOME" with
    | Some cache_home -> cache_home ^ "/mlpreview/"
    | None -> Sys.getenv "HOME" ^ "/.cache/mlpreview/"
  in

  (* create cache dir if it doesn't exist *)
  if not @@ Sys.file_exists dirpath then Sys.mkdir dirpath 0o755;

  dirpath

let get_cache_file file_name cache_type =
  let hash = Digest.MD5.file file_name |> Digest.to_hex in

  cache_dir ^ hash ^ match cache_type with `TEXT -> ".txt" | `THUMB -> ".png"
