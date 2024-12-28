(** Render images using chafa *)
val image : width:int -> height:int -> string -> in_channel

(** Generate thumbnails with quicklook and render images using chafa *)
val ql : width:int -> height:int -> string -> in_channel
