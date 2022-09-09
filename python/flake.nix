{
  description = "";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    utils.url = github:numtide/flake-utils;
    poetry2nix.url = github:nix-community/poetry2nix;
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    inputs.utils.lib.eachDefaultSystem (system:
      let
        overlay = nixpkgs.lib.composeManyExtensions [
          inputs.poetry2nix.overlay
        ];

        pkgs.nix = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ overlay ];
        };

        lib = pkgs.lib;
        stdenv = pkgs.nix.stdenvNoCC;
        mkShell = pkgs.nix.mkShell.override { inherit stdenv; };

      in {
        devShell = mkShell {
          packages = (with pkgs.nix; [
            python3
            python3Packages.poetry
            (poetry2nix.mkPoetryEnv { projectDir = ./.; })
          ]);

          shellHook = ''
            export PATH=$PWD/util:$PATH
          '';
        };
      }
    );
}
