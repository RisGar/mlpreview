open Ctypes

module Types (F : Ctypes.TYPE) = struct
  open F

  (** wrapper type for error codes returned by libarchive *)
  type error_code =
    | ARCHIVE_OK
    | ARCHIVE_EOF
    | ARCHIVE_RETRY
    | ARCHIVE_WARN
    | ARCHIVE_FAILED
    | ARCHIVE_FATAL

  let int_of_error_code = function
    | ARCHIVE_OK -> 0
    | ARCHIVE_EOF -> 1
    | ARCHIVE_RETRY -> -10
    | ARCHIVE_WARN -> -20
    | ARCHIVE_FAILED -> -25
    | ARCHIVE_FATAL -> -30

  let error_code_of_int = function
    | 0 -> ARCHIVE_OK
    | 1 -> ARCHIVE_EOF
    | -10 -> ARCHIVE_RETRY
    | -20 -> ARCHIVE_WARN
    | -25 -> ARCHIVE_FAILED
    | -30 -> ARCHIVE_FATAL
    | _ -> failwith "invalid archive status code"

  let string_of_error_code = function
    | ARCHIVE_OK -> "ARCHIVE_OK"
    | ARCHIVE_EOF -> "ARCHIVE_EOF"
    | ARCHIVE_RETRY -> "ARCHIVE_RETRY"
    | ARCHIVE_WARN -> "ARCHIVE_WARN"
    | ARCHIVE_FAILED -> "ARCHIVE_FAILED"
    | ARCHIVE_FATAL -> "ARCHIVE_FATAL"

  let error_code = view ~read:error_code_of_int ~write:int_of_error_code int

  (* archive *)
  type archive

  let archive : archive structure typ = structure "archive"

  (* archive_entry *)
  type archive_entry

  let archive_entry : archive_entry structure typ = structure "archive_entry"

  (* stat *)
  type stat

  let stat : stat structure typ = structure "stat"
end
