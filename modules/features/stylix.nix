{
  self,
  inputs,
  theme,
  ...
}: {
  flake.homeModules.stylix = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.stylix.homeModules.stylix
    ];
    stylix = let
    in {
      enable = true;
      base16Scheme = theme.colors.base16;

      # Colorscheme
      polarity =
        if theme.colors.dark
        then "dark"
        else "light";

      # Wallpaper
      image = ../../assets/wallpaper.png;

      # Fonts
      fonts = let
        packages = theme.fonts.packages pkgs;
        mainFont = packages.main;
        monoFont = packages.mono;
        emojiFont = packages.emoji;
        mkFont = package: name: {
          inherit name;
          inherit package;
        };
      in {
        serif = mkFont mainFont theme.fonts.family.serif;
        sansSerif = mkFont mainFont theme.fonts.family.sansSerif;
        monospace = mkFont monoFont theme.fonts.family.mono;
        emoji = mkFont emojiFont theme.fonts.family.emoji;
        sizes = {
          terminal = pkgs.lib.toInt theme.fonts.size.terminal;
          desktop = pkgs.lib.toInt theme.fonts.size.desktop;
          popups = pkgs.lib.toInt theme.fonts.size.popups;
        };
      };

      # Icons
      # https://github.com/PapirusDevelopmentTeam/papirus-folders
      icons = {
        enable = true;
        dark = theme.icons.dark;
        light = theme.icons.light;
        package = theme.icons.package pkgs;
      };

      # Cursor
      cursor = {
        name = theme.cursor.name;
        package = theme.cursor.package pkgs;
        size = pkgs.lib.toInt theme.cursor.size;
      };

      # Fix apps
      targets = {
        qt.enable = true;
        gtk.enable = true;
        fuzzel.enable = true;
        waybar.font = "sansSerif";
        zen-browser = {
          enable = true;
          profileNames = ["default"];
        };
        # https://github.com/nix-community/stylix/issues/1560
        gtk.extraCss = ''
          .dialog-action-area > .text-button {
            color: @dialog_fg_color;
          }
        '';
        # Fix flatpaks
        # https://github.com/nix-community/stylix/issues/1093
        gtk.flatpakSupport.enable = false;
        # Disable targets that are already set
        kitty.enable = false;
        bat.enable = false;
        fzf.enable = false;
        nushell.enable = false;
        noctalia-shell.enable = false;
      };

      # Fix home manager warning
      overlays.enable = false;
    };

    # Fix warning
    gtk.gtk4.theme = null;
  };
}
