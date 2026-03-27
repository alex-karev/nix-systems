# Machine-specific configurations
{
  self,
  inputs,
  username,
  withSystem,
  ...
}: {
  flake.nixosModules.common = {
    pkgs,
    lib,
    ...
  }: let
    system = pkgs.stdenv.hostPlatform.system;
    kits = withSystem system ({packageKits, ...}: packageKits);
  in {
    # Enable flakes
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Optimization
    nix.optimise = {
      automatic = true;
      dates = ["daily"];
    };

    # Garbage collection
    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    # Pin nixpkgs flake input to system version
    # TODO: Fix
    # nix.registry.nixpkgs.flake = nixpkgs;

    # Only update nix repo once in 10 days
    nix.settings.tarball-ttl = 864000;

    # Disable man cache (builds faster)
    documentation.man.cache.enable = false;

    # Bootloader
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.tmp.cleanOnBoot = true;

    # Additional kernel parameters
    boot.kernelParams = ["net.ifnames=0"];

    # Clean logs
    services.journald = {
      extraConfig = ''
        SystemMaxUse=500M
        SystemKeepFree=100M
        MaxFileSec=7day
      '';
    };

    # Optimize coredumps
    systemd.coredump = {
      enable = false;
      extraConfig = ''
        ProcessSizeMax=100M
        ExternalSizeMax=50M
        MaxUse=200M
        KeepFree=100M
      '';
    };

    # Timezone and locale
    time.timeZone = "Asia/Shanghai";
    i18n = let
      locale = "en_US.UTF-8";
    in {
      defaultLocale = locale;
      extraLocaleSettings = {
        LC_ADDRESS = locale;
        LC_IDENTIFICATION = locale;
        LC_MEASUREMENT = locale;
        LC_MONETARY = locale;
        LC_NAME = locale;
        LC_NUMERIC = locale;
        LC_PAPER = locale;
        LC_TELEPHONE = locale;
        LC_TIME = locale;
      };
    };

    # Enable tailscale
    networking.firewall.allowedUDPPorts = [41641];
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      extraDaemonFlags = ["--no-logs-no-support"];
      extraSetFlags = ["--operator=${username}"];
    };

    # Enable podman
    virtualisation.containers.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = false; # Disable docker
      defaultNetwork.settings.dns_enabled = true;
    };

    # Add flatpak repo
    systemd.services.flatpak-repo = {
      wantedBy = ["multi-user.target"];
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    # Install essential system packages
    environment.systemPackages = kits.system;

    # Enable git
    programs.git = {
      package = self.packages.${system}.git;
      enable = true;
      lfs.enable = true;
    };

    # Enable ssh agent
    programs.ssh = {
      # startAgent = true;
      extraConfig = ''
        Host *
            AddKeysToAgent yes
      '';
    };

    # Setup user
    users.users.${username} = {
      shell = self.packages.${system}.nushell;
      isNormalUser = true;
      description = username;
      extraGroups = ["networkmanager" "wheel" "video" "render" "seat" "kvm"];
    };
  };
}
