let binary file_name =
  Printf.sprintf "hexdump -C \"%s\"" file_name |> Unix.open_process_in
;;
