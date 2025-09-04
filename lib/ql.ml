let generate_thumb file_name cache_dir cache_file =
  (* create quicklook thumbnail *)
  Printf.sprintf "qlmanage -t \"%s\" -s 800 -o \"%s\"" file_name cache_dir
  |> Unix.open_process_in |> ignore;
  (* rename to hash *)
  Sys.rename (cache_dir ^ Filename.basename file_name ^ ".png") cache_file

let ql ~width ~height file =
  let cache_file = Helpers.get_cache_file file `THUMB in
  (* create thumbnail if it doesn't exist *)
  if not @@ Sys.file_exists cache_file then
    generate_thumb file Helpers.cache_dir cache_file;
  Image.image cache_file ~width ~height
