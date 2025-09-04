open Ctypes

module Types (F : Ctypes.TYPE) = struct
  open F

  (* fz_context *)
  type fz_context

  let fz_context_s : fz_context structure typ = structure ""
  let context = typedef fz_context_s "fz_context"

  (* fz_alloc_context *)
  type fz_alloc_context

  let fz_alloc_context_s : fz_alloc_context structure typ = structure ""
  let alloc_context = typedef fz_alloc_context_s "fz_alloc_context"

  (* fz_locks_context *)
  type fz_locks_context

  let fz_locks_context_s : fz_locks_context structure typ = structure ""
  let locks_context = typedef fz_locks_context_s "fz_locks_context"

  (* fz_document *)
  type fz_document

  let fz_document_s : fz_document structure typ = structure ""
  let document = typedef fz_document_s "fz_document"

  (* fz_pixmap *)
  type fz_pixmap

  let fz_pixmap_s : fz_pixmap structure typ = structure ""
  let pixmap = typedef fz_pixmap_s "fz_pixmap"

  (* fz_matrix, is passed directly so not-opaque *)
  type fz_matrix

  let fz_matrix_s : fz_matrix structure typ = structure ""
  let matrix = typedef fz_matrix_s "fz_matrix"
  let a = field matrix "a" float
  let b = field matrix "b" float
  let c = field matrix "c" float
  let d = field matrix "d" float
  let tx = field matrix "e" float
  let ty = field matrix "f" float
  let () = seal matrix

  (* fz_colorspace *)
  type fz_colorspace

  let fz_colorspace_s : fz_colorspace structure typ = structure ""
  let colorspace = typedef fz_colorspace_s "fz_colorspace"

  (* fz_store_* *)
  let store_default = constant "FZ_STORE_DEFAULT" uint
end
