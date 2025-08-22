open Mupdf.C.Functions
open Mupdf.C.Types
open Ctypes

let identity_matrix =
  let m = make fz_matrix_s in
  setf m a 1.0;
  setf m b 0.0;
  setf m c 0.0;
  setf m d 1.0;
  setf m tx 0.0;
  setf m ty 0.0;
  m

let render_pdf file_name cache_file =
  let ctx =
    new_context
      (from_voidp alloc_context null)
      (from_voidp locks_context null)
      store_default
  in
  if is_null ctx then failwith "error: cannot create mupdf context" else ();
  register_document_handlers ctx;

  let doc = open_document ctx file_name in

  let pix =
    new_pixmap_from_page_number ctx doc 0 identity_matrix (device_rgb ctx) 0
  in

  save_pixmap_as_png ctx pix cache_file;

  drop_pixmap ctx pix;
  drop_document ctx doc;
  drop_context ctx

let pdf ~width ~height file_name =
  let cache_file = Helpers.get_cache_file file_name THUMB in
  (* create thumbnail if it doesn't exist *)
  if not @@ Sys.file_exists cache_file then render_pdf file_name cache_file;
  Image.image cache_file ~width ~height
