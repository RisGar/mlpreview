{
  description = "mlpreview";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      supportedSystems = nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = nixpkgs.lib.genAttrs supportedSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          ocamlPackages = pkgs.ocamlPackages // {
            spectrum = ocamlPackages.buildDunePackage {
              pname = "spectrum";
              version = "0.6.1";
              src = pkgs.fetchFromGitHub {
                owner = "RisGar";
                repo = "ocaml-spectrum";
                rev = "437e3797de66fa919703409665c5a1ef2df09328";
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

          buildInputs = [
            # OCaml dependencies
            ocamlPackages.cmdliner
            ocamlPackages.ctypes
            ocamlPackages.spectrum

            # Linking dependencies (make available for dynamic linking)
            pkgs.libarchive
            pkgs.mupdf

            # CLI dependencies
            pkgs.eza
            pkgs.ffmpeg
            pkgs.bat
          ];

          nativeBuildInputs = [
            ocamlPackages.ocaml
            # the dune build system
            ocamlPackages.dune_3

            # Additionally, add any development packages you want
            ocamlPackages.utop
            ocamlPackages.merlin
            ocamlPackages.lsp
            ocamlPackages.ocamlformat
            ocamlPackages.ocp-indent
          ];
        in
        {
          default = ocamlPackages.buildDunePackage {
            pname = "mlpreview";
            version = "0.0.3";
            duneVersion = "3";
            src = ./.;

            strictDeps = true;

            inherit nativeBuildInputs buildInputs;
          };
        }
      );

      devShells = nixpkgs.lib.genAttrs supportedSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          ocamlPackages = pkgs.ocamlPackages // {
            spectrum = ocamlPackages.buildDunePackage {
              pname = "spectrum";
              version = "0.6.1";
              src = pkgs.fetchFromGitHub {
                owner = "RisGar";
                repo = "ocaml-spectrum";
                rev = "437e3797de66fa919703409665c5a1ef2df09328";
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

          buildInputs = [
            ocamlPackages.cmdliner
            ocamlPackages.ctypes
            ocamlPackages.spectrum

            # Ensure these are available in the shell for linking/testing
            pkgs.libarchive
            pkgs.mupdf

            pkgs.eza
            pkgs.ffmpeg
            pkgs.bat
          ];

          nativeBuildInputs = [
            ocamlPackages.ocaml
            ocamlPackages.dune_3
            ocamlPackages.utop
            ocamlPackages.merlin
            ocamlPackages.lsp
            ocamlPackages.ocamlformat
            ocamlPackages.ocp-indent
          ];
        in
        {
          default = pkgs.mkShell { inherit nativeBuildInputs buildInputs; };
        }
      );
    };
}
