(* TODO: Custom Kitty Graphics Protocol *)
let image ~width ~height file_name =
  let stream =
    Printf.sprintf "chafa --size %sx%s -f kitty --passthrough tmux \"%s\""
      (string_of_int width) (string_of_int height) file_name
    |> Unix.open_process_in
  in
  let ret = In_channel.input_all stream in
  In_channel.close stream;
  ret

let generate_thumb file_name cache_dir cache_file =
  (* create quicklook thumbnail *)
  Printf.sprintf "qlmanage -t \"%s\" -s 800 -o \"%s\"" file_name cache_dir
  |> Unix.open_process_in |> ignore;
  (* rename to hash *)
  Sys.rename (cache_dir ^ Filename.basename file_name ^ ".png") cache_file

let ql ~width ~height file_name =
  let cache_file = Helpers.get_cache_file file_name THUMB in
  (* create thumbnail if it doesn't exist *)
  if not @@ Sys.file_exists cache_file then
    generate_thumb file_name Helpers.cache_dir cache_file;
  image cache_file ~width ~height
