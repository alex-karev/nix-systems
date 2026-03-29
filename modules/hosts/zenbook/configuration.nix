# Machine-specific configurations
{
  self,
  inputs,
  withSystem,
  username,
  ...
}: {
  flake.nixosModules.zenbookConfiguration = {
    pkgs,
    lib,
    config,
    ...
  }: let
    # Install packages
    system = pkgs.stdenv.hostPlatform.system;
    kits = withSystem system ({packageKits, ...}: packageKits);
    webapps = withSystem system ({webapps, ...}: webapps);
    packages = with kits;
      base-cli
      ++ ai-cli
      ++ dev-cli
      ++ base-ui
      ++ dev-ui
      ++ gamedev
      ++ office
      ++ multimedia
      ++ vm
      # ++ webapps
      ++ (with pkgs; []);
  in {
    # Import modules
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.zenbookHardware
      self.nixosModules.common
      self.nixosModules.direnv
      self.nixosModules.wayland
      self.nixosModules.fcitx
      self.nixosModules.niri
      self.nixosModules.obs
      self.nixosModules.flatpak
    ];

    # Set hostname
    networking.hostName = "zenbook";

    # Set home manager and modules
    home-manager = {
      useGlobalPkgs = true;
      users.${username} = {
        imports = [
          self.homeModules.stylix
          self.homeModules.git
          self.homeModules.gowall
          self.homeModules.hide
          self.homeModules.browser
          self.homeModules.webapps
          self.homeModules.winapps
          {
            home.username = username;
            home.homeDirectory = "/home/${username}";
            home.stateVersion = "25.05";
          }
        ];
      };
    };

    # Install fonts
    fonts.packages = kits.fonts; 

    # Enable hardware features
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services.printing.enable = true;
    services.hardware.bolt.enable = true;

    # Enable vulkan and opengl
    hardware.enableRedistributableFirmware = true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva-vdpau-driver
        # rocmPackages.clr
        # rocmPackages.clr.icd
      ];
    };

    # Add cpu-related modules and kernel parametes
    boot.initrd.kernelModules = ["amdgpu"];
    boot.kernelModules = ["zenpower" "amd-pstate"];
    boot.extraModulePackages = [config.boot.kernelPackages.zenpower];
    boot.kernelParams = ["amdgpu" "amd_pstate=active" "initcall_blacklist=acpi_cpufreq_init"];
    boot.blacklistedKernelModules = ["k10temp"];

    # More on amd_pstate and governors:
    # https://www.reddit.com/r/linux/comments/15p4bfs/amd_pstate_and_amd_pstate_epp_scaling_driver/

    # CPU and Battery optimization
    services.tlp = {
      enable = true;
      settings = {
        # On battery
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        # On AC
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        # Charge limits
        # https://linrunner.de/tlp/settings/bc-vendors.html
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80; # 40, 60, 80
        #CPU clock
        #CPU_MIN_PERF_ON_AC = 0;
        #CPU_MAX_PERF_ON_AC = 100;
        #CPU_MIN_PERF_ON_BAT = 0;
        #CPU_MAX_PERF_ON_BAT = 20;
        # Wifi powersave
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
      };
    };

    # Enable battery tracking
    services.upower.enable = true;
    services.upower.percentageLow = 15;
    services.upower.percentageCritical = 5;
    services.upower.criticalPowerAction = "Hibernate";

    # Fix audio
    services.pipewire.wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/90-alsa-profile-fix.conf" ''
        monitor.alsa.rules = [
          {
            matches = [
              { device.name = "~alsa_card.*"; }
            ];
            actions = {
              update-props = {
                device.profile = "HiFi";
                api.alsa.use-acp = true;
                api.acp.auto-profile = true;
              };
            };
          }
        ];
      '')
    ];

    # Install packages
    environment.systemPackages =
      packages
      ++ [
        # WiFi reset script for mt7921e driver issues
        (pkgs.writeShellScriptBin "wifi-reset" ''
          #!/usr/bin/env bash
          echo "Reloading mt7921e WiFi driver..."
          modprobe -r mt7921e
          sleep 1
          modprobe mt7921e
          echo "WiFi driver reloaded successfully"
        '')
      ];

    # Set defaults
    environment.sessionVariables = let
      nvim = lib.getExe self.packages.${system}.nixvim;
    in {
      EDITOR = nvim;
      MANPAGER = "${nvim} +Man!";
    };

    # System stateVersion
    system.stateVersion = "25.05";
  };
}
