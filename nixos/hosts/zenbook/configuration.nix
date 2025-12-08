{
  pkgs,
  config,
  ...
}: {
  # Hardware setup (auto-generated)
  imports = [./hardware-configuration.nix];

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

  # Thunderbolt
  services.hardware.bolt.enable = true;

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
}
