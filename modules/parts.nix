{inputs, ...}: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  config = {
    # Declare allowed system
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];

    # Set username
    _module.args = {
      systemFlakePath = "~/System";
      username = "alex";
    };

    # Allow unfree packages
    perSystem = {system, ...}: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
  };
}
