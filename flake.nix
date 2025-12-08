{
  description = "NixOS and Home-manager Flake by alex-karev";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    prismlauncher = {
      url = "github:ElyPrismLauncher/ElyPrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixohess = {
      url = "gitlab:fazzi/nixohess";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "path:./nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    scripts = {
      url = "path:./scripts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bubblewrap = {
      url = "path:./bubblewrap";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # Helper functions
    mkSystem = import ./nixos.nix {inherit inputs;};
    mkHome = import ./home.nix {inherit inputs;};
  in {
    # NixOS configurations
    nixosConfigurations = {
      # Zenbook laptop
      zenbook = mkSystem {
        system = "x86_64-linux";
        hostname = "zenbook";
        username = "alex";
        caps.bluetooth = true;
        caps.coredump = true;
        modules = [
          ./nixos/modules/wayland.nix
          ./nixos/modules/gaming.nix
          ./nixos/modules/obs.nix
        ];
        home = mkHome {
          system = "x86_64-linux";
          hostname = "zenbook";
          modules = [
            ./home/modules/stylix.nix
            ./home/modules/shell.nix
            ./home/modules/fcitx.nix
            ./home/modules/wm.nix
            ./home/modules/hide.nix
            ./home/modules/webapps.nix
            ./home/modules/niri.nix
            ./home/modules/waybar.nix
            ./home/modules/apps.nix
            ./home/modules/browser.nix
          ];
        };
      };
    };

    # Home manager configurations (standalone)
    homeConfigurations = {
      # newDevice = home-manager.lib.homeManagerConfiguration mkSystem {...}
    };

    # Devshell (for direnv)
    devShells = import ./shell.nix {inherit nixpkgs;};
  };
}
