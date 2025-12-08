{
  description = "My Nixvim config file";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixvim,
    ...
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (
      system: let
        nvim = let
          nixvim' = nixvim.legacyPackages.${system};
          config = import ./default.nix;
        in
          nixvim'.makeNixvim config;
      in {
        inherit nvim;
        default = nvim;
      }
    );
    apps = forAllSystems (
      system: {
        nvim = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nvim";
        };
      }
    );
  };
}
