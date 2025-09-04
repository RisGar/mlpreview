let binary file_name =
  let stream =
    Unix.open_process_in @@ Printf.sprintf "hexdump -C \"%s\"" file_name
  in
  print_endline @@ In_channel.input_all stream;
  In_channel.close stream
