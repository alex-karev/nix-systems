{
  pkgs,
  lib,
  hasDisplay,
  config,
  ...
}: {
  stylix = let
    # Colorscheme settings
    # https://tinted-theming.github.io/tinted-gallery/
    # theme = "tomorrow-night";
    # theme = "sandcastle";
    # theme = "catppuccin-mocha";
    # theme = "espresso";
    # theme = "github-dark";
    # theme = "horizon-terminal-dark";
    # theme = "everforest-dark-hard";
    theme = "ayu-dark";
    # theme = "katy";
    schemeSet = pkgs.base16-schemes;
    dark = true;
    override = {};
    # https://github.com/PapirusDevelopmentTeam/papirus-folders
    iconColor = "nordic";
  in {
    enable = true;
    base16Scheme = "${schemeSet}/share/themes/${theme}.yaml";

    # Colorscheme
    polarity =
      if dark
      then "dark"
      else "light";

    # Override colors in colorscheme
    inherit override;

    # Wallpaper
    image = lib.mkIf hasDisplay ../../assets/wallpaper.png;

    # Fonts
    fonts = let
      mainFont = pkgs.nerd-fonts.fantasque-sans-mono;
      emojiFont = pkgs.twemoji-color-font;
      mkFont = package: name: {
        inherit name;
        inherit package;
      };
    in {
      serif = mkFont mainFont "FantasqueSansM Nerd Font";
      sansSerif = mkFont mainFont "FantasqueSansM Nerd Font";
      monospace = mkFont mainFont "FantasqueSansM Nerd Font Mono";
      emoji = mkFont emojiFont "Twitter Color Emoji";
      sizes = {
        terminal = 14;
        desktop = 12;
        popups = 14;
      };
    };

    # Icons
    icons = lib.mkIf hasDisplay {
      enable = true;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
      package = pkgs.papirus-icon-theme.override {
        color = iconColor;
      };
    };

    # Cursor
    cursor = lib.mkIf hasDisplay {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };

    # Fix apps
    targets = {
      qt.enable = lib.mkIf hasDisplay true;
      waybar.font = lib.mkIf hasDisplay "sansSerif";
      librewolf = {
        enable = true;
        profileNames = ["default"];
      };
    };

    # Fix home manager warning
    overlays.enable = false;
  };
}
