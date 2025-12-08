{
  description = "Package set with sandboxed applications";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    wpsoffice = {
      url = "github:alex-karev/wpsoffice-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    wpsoffice,
  }: let
    # Define supported systems
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

    # Generate packages for one system
    pkgsForSystem = system: let
      pkgs = import nixpkgs {
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) ["wechat" "wemeet" "libwemeetwrap" "wechat-uos"];
        inherit system;
      };

      packageSet = import ./package.nix {inherit pkgs;};
    in {
      wpsoffice = wpsoffice.packages."${system}".default;
      wpsoffice-fonts = wpsoffice.packages."${system}".fonts;
      wechat = pkgs.callPackage packageSet.wechat {};
      wemeet = pkgs.callPackage packageSet.wemeet {};
    };

    # Generate app launchers
    appForSystem = system: pkgname: exec: {
      type = "app";
      program = "${self.packages.${system}.${pkgname}}/bin/${exec}";
    };
  in {
    # Generate packages for all systems
    packages = nixpkgs.lib.genAttrs supportedSystems (system: pkgsForSystem system);

    # Generate apps for all systems
    apps = nixpkgs.lib.genAttrs supportedSystems (system: {
      wpsoffice = appForSystem system "wpsoffice" "wps";
      wechat = appForSystem system "wechat" "wechat";
      wemeet = appForSystem system "wemeet" "wemeet";
    });
  };
}
