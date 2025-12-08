# NixOS system generator
{inputs}: let
  nixpkgs = inputs.nixpkgs;
in
  # Function for creating per-device configs
  {
    system,
    username,
    home ? null,
    hostname ? "nixos",
    modules ? [],
    caps ? {},
    timezone ? "Asia/Shanghai",
    locale ? "en_US.UTF-8",
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;

      # Add modules
      modules = let
        pkgs = import nixpkgs {inherit system inputs;};
      in
        [
          # Common configurations
          (import ./nixos/modules/common.nix {
            inherit locale timezone hostname username nixpkgs pkgs inputs system;
            caps =
              {
                tailscale = true;
                coredump = false;
                bluetooth = false;
                cups = false;
              }
              // caps;
          })
          # Host-specific configurations
          (./. + "/nixos/hosts/${hostname}/configuration.nix")
        ]
        # Activate home manager
        ++ (
          if home != null
          then [
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username}.imports = home.modules;
              home-manager.extraSpecialArgs = home.extraSpecialArgs;
            }
          ]
          else []
        )
        # Custom modules
        ++ modules;
    }
