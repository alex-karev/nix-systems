# Enable gnome desktop
{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.gnome = {
    pkgs,
    lib,
    ...
  }: {
    # Enable gnome
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    # Exclude apps
    services.gnome.core-apps.enable = false;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;
    environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];

    #Install nautilus
    services.gvfs.enable = true;
  };
}
