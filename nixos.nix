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

      # Pass arguments to modules
      specialArgs = {
        elyprismlauncher = inputs.prismlauncher.packages.${system}.default;
        stremio = inputs.nixohess.packages.${system}.stremio-linux-shell;
      };

      # Add modules
      modules = let
        pkgs = import nixpkgs {inherit system inputs;};
      in
        [
          # Add nixpkgs overlays
          {
            nixpkgs.overlays = import ./packages.nix {inherit inputs system;};
          }

          # Common configurations
          (import ./nixos/modules/common.nix {
            inherit locale timezone hostname username nixpkgs pkgs;
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
