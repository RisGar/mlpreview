{
  description = "mlpreview";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, self, ... }:
    let
      supportedSystems = nixpkgs.lib.systems.flakeExposed;

      mkOcamlEnv =
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
            # CLI dependencies
            pkgs.eza
            pkgs.ffmpeg
            pkgs.bat
          ];

          buildInputs = [
            # OCaml dependencies
            ocamlPackages.cmdliner
            ocamlPackages.ctypes
            ocamlPackages.spectrum

            # Linked libraries
            pkgs.libarchive
            pkgs.mupdf
          ];

          nativeBuildInputs = [
            ocamlPackages.ocaml
            ocamlPackages.dune_3

            # For finding C libraries
            pkgs.pkg-config

            # For wrapping executables with PATH
            pkgs.makeWrapper
          ];

        in
        {
          inherit
            buildInputsCli
            nativeBuildInputs
            ocamlPackages
            pkgs
            ;

          buildInputs = buildInputs ++ buildInputsCli;
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

            postInstall = ''
              # Wrap installed executables to include required CLI tools on PATH
              wrapProgram "$out/bin/mlpreview" --prefix PATH : "${env.pkgs.lib.makeBinPath env.buildInputsCli}"
            '';
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

      overlays.default = f: p: { mlpreview = self.packages.${p.system}.default; };
      overlay = self.overlays.default;

    };
}
