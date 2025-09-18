(lang dune 3.19)

(name mlpreview)

(version 0.0.3)

(generate_opam_files true)

(source
 (github RisGar/mlpreview))

(authors "Rishab Garg <contact@rishab-garg.me>")

(license EUPL-v1.2)

; (documentation https://url/to/documentation)

(using ctypes 0.3)

(package
 (name mlpreview)
 (synopsis "Preview files in the terminal")
 (description "A file previewer for the lf terminal file manager")
 (depends ocaml cmdliner spectrum ctypes)
 (tags
  ("terminal" "cli")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
