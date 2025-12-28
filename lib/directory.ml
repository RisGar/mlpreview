let directory file_name =
  let stream =
    Unix.open_process_in
    @@ Printf.sprintf
         "eza -a1F --color=always --group-directories-first --icons=always \
          --git \"%s\""
         file_name
  in
  print_endline @@ In_channel.input_all stream;
  In_channel.close stream
