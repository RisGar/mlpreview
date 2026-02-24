{
  description = "mlpreview";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.callPackage ./. { };
      });

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          mlpreview = pkgs.callPackage ./. { };
        in
        {
          default = pkgs.mkShell {
            inputsFrom = [ mlpreview ];

            nativeBuildInputs = [
              pkgs.ocamlPackages.utop
              pkgs.ocamlPackages.ocaml-lsp
              pkgs.ocamlPackages.ocamlformat
            ];
          };
        }
      );

      overlays.default = final: prev: {
        mlpreview = prev.callPackage ./. { };
      };
    };
}
