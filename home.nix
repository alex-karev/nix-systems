{inputs}: let
  nixpkgs = inputs.nixpkgs;
in
  {
    # Default parameters
    system,
    hostname,
    modules ? [],
    hasDisplay ? true,
    homePath ? "~/System",
    systemPath ? "~/System",
    droidPath ? "~/Droid",
  }: {
    # Activate modules
    modules =
      [
        inputs.stylix.homeModules.stylix
        inputs.niri.homeModules.niri
        inputs.niri.homeModules.stylix
        ./home/modules/common.nix
      ]
      ++ modules;

    # Packages
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = import ./packages.nix {inherit system inputs;};
    };

    # Expose system info
    extraSpecialArgs = {
      inherit nixpkgs hostname homePath systemPath droidPath hasDisplay;
    };
  }
