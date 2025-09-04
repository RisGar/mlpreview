val ( << ) : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c
(** B combinator / Function composition *)

val get_mime : string -> string
(** Get the mime type of a file *)

val cache_dir : string
(** Cache dir using xdg variable if avaliable *)

val get_cache_file : string -> [ `TEXT | `THUMB ] -> string
(** [get_cache_file file_name type] returns the name of the cache file for the
    specified file and type *)
