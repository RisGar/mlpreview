(* TODO: Custom Kitty Graphics Protocol *)
let image ~width ~height file =
  let img = Result.get_ok (Stb_image.load ~channels:4 file) in
  let img_s = Kittyimg.string_of_bytes_ba img.Stb_image.data in

  print_newline ();
  Kittyimg.send_image ~w:width ~h:height ~format:`RGBA
    ~mode:(`Display (Kittyimg.display_opts ()))
    img_s;
  print_newline ()
