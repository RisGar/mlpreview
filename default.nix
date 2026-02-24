{
  lib,
  stdenv,
  eza,
  ffmpeg,
  bat,
  libarchive,
  mupdf,
  pkg-config,
  makeWrapper,
  ocamlPackages,
  fetchFromGitHub,
}:

let
  ocamlPackages' = ocamlPackages // {
    spectrum = ocamlPackages.buildDunePackage {
      pname = "spectrum";
      version = "0.6.1";
      src = fetchFromGitHub {
        owner = "RisGar";
        repo = "ocaml-spectrum";
        rev = "v0.6.1";
        hash = "sha256-aEATXTSbRA5Y0fO71Ca4+OGr7NTBJjQl+ecr3LacqlE=";
      };
      propagatedBuildInputs = [
        ocamlPackages.color
        ocamlPackages.ppx_deriving
        ocamlPackages.opam-state
        ocamlPackages.pcre2
      ];
    };
  };

  buildInputsCli = [
    eza
    ffmpeg
    bat
  ];

in
ocamlPackages'.buildDunePackage {
  pname = "mlpreview";
  version = "0.0.3";
  duneVersion = "3";

  meta = {
    mainProgram = "mlpreview";
    license = lib.licenses.eupl12;
  };

  src = ./.;

  strictDeps = true;

  buildInputs = [
    # OCaml dependencies
    ocamlPackages'.cmdliner
    ocamlPackages'.ctypes
    ocamlPackages'.spectrum

    # Linked libraries
    libarchive
    mupdf
  ]
  ++ buildInputsCli;

  nativeBuildInputs = [
    ocamlPackages'.ocaml
    ocamlPackages'.dune_3
    pkg-config
    makeWrapper
  ];

  postInstall = ''
    wrapProgram "$out/bin/mlpreview" --prefix PATH : "${lib.makeBinPath buildInputsCli}"
  '';
}
