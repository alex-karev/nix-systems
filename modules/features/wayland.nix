# Wayland-specific settings
{
  self,
  inputs,
  theme,
  ...
}: {
  flake.nixosModules.wayland = {
    pkgs,
    lib,
    ...
  }: {
    # Enable polkit
    security.polkit.enable = true;

    # Activate gnome keyring
    services.gnome.gnome-keyring.enable = true;

    # Pinentry (needed for rbw)
    services.dbus.packages = [pkgs.gcr];

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

    # Enable usb automaunt
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.devmon.enable = true;

    # Enable default fonts
    fonts.enableDefaultPackages = true;
  };
}
