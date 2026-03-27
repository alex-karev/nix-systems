# Windows emulator
# TODO: make into a package
{
  self,
  inputs,
  theme,
  ...
}: {
  flake.homeModules.winapps = {
    config,
    pkgs,
    lib,
    ...
  }: let
    # Common variables
    username = "Alex";
    password = "0000";
    mount = "\${HOME}/Shared";

    # Winapps config
    winappsConfig = {
      RDP_USER = username;
      RDP_PASS = password;
      RDP_DOMAIN = "";
      RDP_IP = "127.0.0.1";
      VM_NAME = "RDPWindows";
      WAFLAVOR = "podman";
      RDP_SCALE = "180";
      REMOVABLE_MEDIA = "/run/media";
      RDP_FLAGS = "/cert:tofu /sound /microphone /network:lan /nsc /gfx";
      DEBUG = "true";
      AUTOPAUSE = "off";
      AUTOPAUSE_TIME = "300";
      FREERDP_COMMAND = "";
      PORT_TIMEOUT = "5";
      RDP_TIMEOUT = "30";
      APP_SCAN_TIMEOUT = "60";
      BOOT_TIMEOUT = "120";
      HIDEF = "on";
    };

    # Winapps container
    composeFile = {
      name = "winapps";
      services = {
        windows = {
          image = "ghcr.io/dockur/windows:latest";
          container_name = "WinApps";
          environment = {
            VERSION = "11";
            RAM_SIZE = "4G";
            CPU_CORES = "4";
            DISK_SIZE = "64G";
            USERNAME = username;
            PASSWORD = password;
            HOME = mount;
          };
          ports = [
            "8006:8006"
            "3389:3389/tcp"
            "3389:3389/udp"
          ];
          cap_add = ["NET_ADMIN"];
          stop_grace_period = "120s";
          restart = "on-failure";
          volumes = [
            "./data:/storage"
            "${mount}:/shared"
            "./oem:/oem"
          ];
          devices = ["/dev/kvm" "/dev/net/tun"];
          group_add = ["keep-groups"];
        };
      };
    };

    # Convert config to string
    winappsConfigStr =
      lib.concatStringsSep "\n"
      (
        lib.mapAttrsToList
        (k: v: "${k}=\"${v}\"")
        winappsConfig
      );

    # Convert docker compose to string
    composeFileStr = builtins.toJSON composeFile;
  in {
    # Install packages
    home.packages = with pkgs; [
      inputs.winapps.packages."${pkgs.stdenv.hostPlatform.system}".winapps
      freerdp
      podman-compose
    ];

    # Generate configs
    home.file.".config/winapps/winapps.conf".text = winappsConfigStr;
    home.file.".config/winapps/compose.yaml".text = composeFileStr;
  };
}
