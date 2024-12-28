(** Print [in_channel] and close it *)
val print_in_stream : in_channel -> unit

(** Get the mime type of a file *)
val get_mime : string -> string

(** Cache dir using xdg variable if avaliable *)
val cache_dir : string

(** Type of cache file  *)
type cache_type = THUMB | ARCHIVE

(** [get_cache_file file_name type] returns the name of the cache file for the specified file and type *)
val get_cache_file : string -> cache_type -> string
