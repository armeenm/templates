{
  description = "";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    utils.url = github:numtide/flake-utils;
  };

  outputs = inputs@{ self, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = {
          nixpkgs = import inputs.nixpkgs {
            inherit system;
          };
        };

        inherit (pkgs.nixpkgs) lib;
        stdenv = pkgs.nixpkgs.llvmPackages_14.stdenv;
        mkShell = pkgs.nixpkgs.mkShell.override { inherit stdenv; };

        packages = rec {
          default = template;
          template = import ./. { inherit pkgs; };
        };

      in {
        inherit packages;

        devShells.default = mkShell {
          hardeningDisable = [ "all" ];
          packages = with pkgs.nixpkgs; [
            fmt_9
            meson
            ninja
            pkg-config
          ];
        };
      }
    );
}
