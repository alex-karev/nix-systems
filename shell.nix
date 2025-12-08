# Devshell (for direnv)
{nixpkgs}: let
  supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
  forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
in
  forEachSystem (system: let
    pkgs = import nixpkgs {inherit system;};
  in {
    default = pkgs.mkShell {
      name = "nix";
    };
  })
