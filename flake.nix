{
  description = "css-variables-language-server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      perSystem = { config, system, pkgs, ... }:
        let
          nodejs = pkgs.nodejs;
          v2 = import ./versions/v2 {
            inherit pkgs;
            inherit system;
            inherit nodejs;
          };
        in
        {
          overlayAttrs = {
            css-variables-language-server = v2.package;
          };
          packages = {
            default = v2.package;
          };
          devShells = {
            default = pkgs.mkShell {
              packages = [
                pkgs.just
                pkgs.node2nix
              ];
            };
          };
        };
    };
}

