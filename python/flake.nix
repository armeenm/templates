{
  description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, ... }: let
    config = {
      allowUnfree = true;
    };

    forAllSystems = f: nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ] (system: f system (
      import nixpkgs { inherit system config; }
    ));

  in {
    devShells = forAllSystems (system: pkgs: with pkgs; {
      default = mkShell rec {
        packages = [
          python3
          pdm
        ];

        libs = nixpkgs.lib.makeLibraryPath [
          stdenv.cc.cc.lib
        ];

        shellHook = ''
        export PATH=$PWD/util:$PATH
        export LD_LIBRARY_PATH=${libs}:$LD_LIBRARY_PATH
        '';
      };
    });
  };
}
