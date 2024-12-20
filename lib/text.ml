let text file_name =
  Printf.sprintf "bat -pp --color always --wrap character -- \"%s\"" file_name
  |> Unix.open_process_in
;;
