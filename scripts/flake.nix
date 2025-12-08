{
  description = "A set of custom scripts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    # Define supported systems
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

    # Generate packages for one system
    pkgsForSystem = system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      fcitx5-scroll = pkgs.callPackage ./fcitx5-scroll.nix {};
      notify-volume = pkgs.callPackage ./notify-volume.nix {};
      notify-brightness = pkgs.callPackage ./notify-brightness.nix {};
      tsexitnode = pkgs.callPackage ./tsexitnode.nix {};
      fuzzel-calc = pkgs.callPackage ./fuzzel-calc.nix {};
      fuzzel-battery = pkgs.callPackage ./fuzzel-battery.nix {};
    };
  in {
    # Generate packages for all systems
    packages = nixpkgs.lib.genAttrs supportedSystems (system: pkgsForSystem system);
  };
}
