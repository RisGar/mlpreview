let text file_name =
  let stream =
    Unix.open_process_in
    @@ Printf.sprintf "bat -pp --color always --wrap character -- \"%s\""
         file_name
  in
  print_endline @@ In_channel.input_all stream;
  In_channel.close stream
