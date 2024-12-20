open Ctypes
open Foreign

type archive
type archive_entry

type archive_status_enum =
  | ARCHIVE_OK
  | ARCHIVE_EOF
  | ARCHIVE_RETRY
  | ARCHIVE_WARN
  | ARCHIVE_FAILED
  | ARCHIVE_FATAL

let archive_status_to_int = function
  | ARCHIVE_OK -> 0
  | ARCHIVE_EOF -> 1
  | ARCHIVE_RETRY -> -10
  | ARCHIVE_WARN -> -20
  | ARCHIVE_FAILED -> -25
  | ARCHIVE_FATAL -> -30
;;

let archive_status = int
let archive : archive structure typ = structure "archive"
let archive_entry : archive_entry structure typ = structure "archive_entry"
let archive_read_new = foreign "archive_read_new" (void @-> returning (ptr archive))
let archive_read_free = foreign "archive_read_free" (ptr archive @-> returning int)

let archive_read_support_filter_all =
  foreign "archive_read_support_filter_all" (ptr archive @-> returning archive_status)
;;

let archive_read_support_format_all =
  foreign "archive_read_support_format_all" (ptr archive @-> returning archive_status)
;;

let archive_read_open_filename =
  foreign
    "archive_read_open_filename"
    (ptr archive @-> string @-> size_t @-> returning archive_status)
;;

let archive_read_next_header =
  foreign
    "archive_read_next_header"
    (ptr archive @-> ptr (ptr archive_entry) @-> returning archive_status)
;;

let archive_entry_pathname_utf8 =
  foreign "archive_entry_pathname_utf8" (ptr archive_entry @-> returning string)
;;

let archive_entry_size =
  foreign "archive_entry_size" (ptr archive_entry @-> returning int64_t)
;;

let archive_entry_stat =
  foreign "archive_entry_stat" (ptr archive_entry @-> returning (ptr void))
;;

let archive_entry_strmode =
  foreign "archive_entry_strmode" (ptr archive_entry @-> returning string)
;;

let archive_entry_mtime =
  foreign "archive_entry_mtime" (ptr archive_entry @-> returning int64_t)
;;
