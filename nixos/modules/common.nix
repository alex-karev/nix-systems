{
  pkgs,
  locale,
  timezone,
  hostname,
  username,
  caps,
  nixpkgs,
  ...
}: {
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
  nix.registry.nixpkgs.flake = nixpkgs;

  # Only update nix repo once in 10 days
  nix.settings.tarball-ttl = 864000;

  # Disable man cache (builds faster)
  documentation.man.generateCaches = false;

  # Bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.tmp.cleanOnBoot = true;

  # Additional kernel parameters
  boot.kernelParams = ["net.ifnames=0"];

  # Set hostname
  networking.hostName = hostname;

  # Timezone and locale
  time.timeZone = timezone;
  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = {
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

  # Enable network
  networking.networkmanager.enable = true;

  # Enable tailscale
  networking.firewall.allowedUDPPorts = pkgs.lib.mkIf caps.tailscale [41641];
  services.tailscale = pkgs.lib.mkIf caps.tailscale {
    enable = true;
    useRoutingFeatures = "client";
    extraDaemonFlags = ["--no-logs-no-support"];
    extraSetFlags = ["--operator=${username}"];
  };

  # Enable bluetooth
  hardware.bluetooth.enable = caps.bluetooth;

  # Enable CUPS to print documents.
  services.printing.enable = caps.cups;

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
    enable = caps.coredump;
    extraConfig = ''
      ProcessSizeMax=100M
      ExternalSizeMax=50M
      MaxUse=200M
      KeepFree=100M
    '';
  };

  # Setup user
  programs.fish.enable = true;
  users.users.${username} = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel" "video" "render" "seat"];
  };

  # Install system packages
  environment.systemPackages = [
    pkgs.iw
  ];

  # System stateVersion
  system.stateVersion = "25.05";
}
