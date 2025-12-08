# Wayland tweaks
{pkgs, ...}: {
  # Enable polkit
  security.polkit.enable = true;

  # XDG portals
  environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];

  # Allow swaylock
  security.pam.services.swaylock = {};

  # Enable dconf
  programs.dconf.enable = true;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Allow brightnessctl without password
  security.sudo.extraRules = [
    {
      commands = [
        {
          command = "${pkgs.brightnessctl}/bin/brightnessctl";
          options = ["NOPASSWD"];
        }
      ];
      groups = ["wheel"];
    }
  ];

  # Enable default fonts
  fonts.enableDefaultPackages = true;
}
