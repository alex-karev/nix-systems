# Install flatpak apps
# TODO: convert to options config format with app selection
{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.flatpak = {
    pkgs,
    lib,
    ...
  }: let
    waylandOnly = ["!x11" "wayland" "!fallback-x11"];
  in {
    # Import modules
    imports = [
      inputs.nix-flatpak.nixosModules.nix-flatpak
    ];

    # Activate flatpak
    services.flatpak = {
      enable = true;

      # Manual update: restart flatpak-managed-install service
      # update.onActivation = true;

      # Delete flatpaks not managed by nix
      uninstallUnmanaged = true;

      # Sandbox all proprietary apps
      packages = [
        # Gaming
        "com.valvesoftware.Steam"
        "com.usebottles.bottles"
        "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/25.08"
        "org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/25.08"
        "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/25.08"
        "org.polymc.PolyMC"
        "page.kramo.Cartridges" # FOSS
        "sh.ppy.osu" # FOSS

        # Social
        "com.discordapp.Discord"
        "org.telegram.desktop"
        "com.tencent.WeChat"
        "com.tencent.wemeet"
        "us.zoom.Zoom"

        # Other
        "com.stremio.Stremio"
        "md.obsidian.Obsidian"
        "com.github.tchx84.Flatseal"
      ];

      # Settings
      overrides = {
        # Global settings
        global = {
          # Disable wayland for most of the apps
          Context.sockets = ["x11" "!wayland"];
          # Fix un-themed cursor in some Wayland apps
          Environment.XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
          # Fix CJK fonts (TODO: narrow down)
          Context.filesystems = ["/nix/store:ro"];
        };

        # Run apps on wayland
        "md.obsidian.Obsidian".Context.sockets = waylandOnly;
        "us.zoom.Zoom".Context.sockets = waylandOnly;
        "org.telegram.desktop".Context.sockets = waylandOnly;
        # "com.discordapp.Discord".Context.sockets = waylandOnly;
        "com.stremio.Stremio".Context.sockets = waylandOnly;
        "page.kramo.Cartridges".Context.sockets = waylandOnly;
        "com.github.tchx84.Flatseal".Context.sockets = waylandOnly;

        # Remove access to private data
        "com.tencent.wemeet".Context.filesystems = ["!home" "~/Downloads/Wemeet:rw"];
        "com.tencent.WeChat".Context.filesystems = ["!home" "!xdg-download" "~/Downloads/Wechat:rw"];
        "com.discordapp.Discord".Context.filesystems = ["!home" "!xdg-download" "!xdg-pictures" "!xdg-videos" "~/Downloads/Discord:rw"];
        "us.zoom.Zoom".Context.filesystems = ["!home" "!xdg-documents"];
        "org.telegram.desktop".Context.filesystems = ["!home" "~/Downloads/Telegram:rw"];
        "md.obsidian.Obsidian".Context.filesystems = ["!home" "~/Data/Notes:rw"];
        "com.valvesoftware.Steam".Context.filesystems = ["!home" "!xdg-music" "!xdg-pictures"];
        "org.polymc.PolyMC".Context.filesystems = ["!home" "!xdg-download"];
        "sh.ppy.osu".Context.filesystems = ["!home" "!~/.osu" "!xdg-videos" "!xdg-download" "!~/.local/share/osu-wine" "!xdg-pictures" "!xdg-music" "!~/.wine"];
      };
    };

    # Symlink fonts
    # TODO
    #home.file.".local/share/fonts/opentype/noto-cjk".source = "${pkgs.noto-fonts-cjk-sans}/share/fonts/opentype/noto-cjk";
  };
}
