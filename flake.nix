{
  description = "mlpreview";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      supportedSystems = nixpkgs.lib.systems.flakeExposed;

      mkOcamlEnv =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          ocamlPackagesBase = pkgs.ocamlPackages;

          ocamlPackages = ocamlPackagesBase // {
            spectrum = ocamlPackagesBase.buildDunePackage {
              pname = "spectrum";
              version = "0.6.1";
              src = pkgs.fetchFromGitHub {
                owner = "RisGar";
                repo = "ocaml-spectrum";
                rev = "437e3797de66fa919703409665c5a1ef2df09328";
                hash = "sha256-aEATXTSbRA5Y0fO71Ca4+OGr7NTBJjQl+ecr3LacqlE=";
              };
              propagatedBuildInputs = [
                ocamlPackagesBase.color
                ocamlPackagesBase.ppx_deriving
                ocamlPackagesBase.opam-state
                ocamlPackagesBase.pcre2
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
            ocamlPackages.dune_3

            # For finding c libraries
            pkgs.pkg-config
          ];

        in
        {
          buildInputs = buildInputs;
          nativeBuildInputs = nativeBuildInputs;
          ocamlPackages = ocamlPackages;
        };

    in
    {
      packages = nixpkgs.lib.genAttrs supportedSystems (
        system:
        let
          env = mkOcamlEnv system;
        in
        {
          default = env.ocamlPackages.buildDunePackage {
            pname = "mlpreview";
            version = "0.0.3";
            duneVersion = "3";
            src = ./.;

            strictDeps = true;

            inherit (env) nativeBuildInputs buildInputs;
          };
        }
      );

      devShells = nixpkgs.lib.genAttrs supportedSystems (
        system:
        let
          env = mkOcamlEnv system;
        in
        {
          default = nixpkgs.legacyPackages.${system}.mkShell {
            inherit (env) buildInputs;

            # Add devShell tools
            nativeBuildInputs = env.nativeBuildInputs ++ [
              env.ocamlPackages.utop
              env.ocamlPackages.ocaml-lsp
              env.ocamlPackages.ocamlformat
            ];
          };
        }
      );
    };
}
