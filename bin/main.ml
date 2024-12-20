open Modules

let match_mime mime file_name width height =
  let chan =
    match mime with
    (* directories *)
    | "inode/directory" -> Some Directory.directory
    (* images *)
    | str when String.starts_with ~prefix:"image" str ->
      Some (Image.image file_name ~width ~height)
    (* [TODO]: archives *)
    | "application/zip" -> Some (Archive.archive file_name)
    (* quicklook: pdfs *)
    | "application/pdf" -> Some (Image.ql file_name ~width ~height)
    (* quicklook: videos *)
    | str when String.starts_with ~prefix:"video" str ->
      Some (Image.ql file_name ~width ~height)
    (* binary *)
    | "application/octet-stream" -> Some (Binary.binary file_name)
    (* empty files *)
    | "inode/x-empty" ->
      print_endline "Empty file";
      None
    (* generic text *)
    | "text/plain" -> Some (Text.text file_name)
    (* everything else *)
    | _ ->
      print_endline mime;
      Some (Text.text file_name)
  in
  match chan with
  | Some chan -> Helpers.print_in_stream chan
  | None -> ()
;;

let match_width_height str num =
  match str with
  | Some x -> int_of_string x
  | None -> num
;;

let () =
  let args = Sys.argv |> Array.to_list in
  if List.length args <= 1
  then Helpers.print_in_stream Directory.directory
  else (
    let file_name = List.nth args 1 in
    let width = match_width_height (List.nth_opt args 2) 160 - 1 in
    let height = match_width_height (List.nth_opt args 3) 40 - 1 in
    let mime = Helpers.get_mime file_name in
    match_mime mime file_name width height)
;;
