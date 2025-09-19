let directory () =
  let stream =
    Unix.open_process_in
    @@ "eza -a1F --color=always --group-directories-first --icons=always --git"
  in
  print_endline @@ In_channel.input_all stream;
  In_channel.close stream
