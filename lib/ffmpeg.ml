let generate_thumb file_name cache_file =
  ignore @@ Unix.open_process_in
  @@ Printf.sprintf "ffmpeg -ss 00:00:01 -i \"%s\" -frames:v 1 \"%s\"" file_name
       cache_file

let thumbnail ~width ~height file =
  let cache_file = Helpers.get_cache_file file `THUMB in

  (* create thumbnail if it doesn't exist *)
  if not @@ Sys.file_exists cache_file then generate_thumb file cache_file;

  Image.image cache_file ~width ~height
