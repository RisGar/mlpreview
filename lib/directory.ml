let directory () =
  let stream =
    Unix.open_process_in
      "eza -a1F --color=always --group-directories-first --icons=always --git"
  in
  stream |> In_channel.input_all |> print_endline;
  In_channel.close stream
