{inputs, ...}: {
  config._module.args.theme = let
    # Overall theme
    # https://tinted-theming.github.io/tinted-gallery/

    # theme = "tomorrow-night";
    # theme = "sandcastle";
    theme = "catppuccin-mocha";
    # theme = "espresso";
    # theme = "github-dark";
    # theme = "horizon-terminal-dark";
    # theme = "everforest-dark-hard";
    # theme = "ayu-dark";
    # theme = "gruvbox-dark";
    # theme = "atelier-plateau-light";
    dark = true;
    primaryColor = "base09";
    secondaryColor = "base0A";
  in {
    # Fonts
    fonts = {
      family = {
        mono = "FantasqueSansM Nerd Font Mono";
        serif = "FantasqueSansM Nerd Font";
        sansSerif = "FantasqueSansM Nerd Font";
        emoji = "Noto Color Emoji";
      };
      packages = pkgs: {
        mono = pkgs.nerd-fonts.fantasque-sans-mono;
        main = pkgs.nerd-fonts.fantasque-sans-mono;
        emoji = pkgs.noto-fonts-color-emoji;
      };
      size = {
        terminal = "14";
        popups = "12";
        desktop = "14";
      };
    };

    # Icons
    icons = {
      dark = "Papirus-Dark";
      light = "Papirus-Light";
      package = pkgs: (pkgs.papirus-icon-theme.override {
        color = "nordic";
      });
    };

    # Cursor
    cursor = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs: pkgs.catppuccin-cursors.mochaDark;
      size = "24";
    };

    # Colorscheme
    colors = let
      paletteRaw = inputs.nix-colors.colorSchemes.${theme}.palette;
      palette = builtins.mapAttrs (_: color: "#${color}") paletteRaw;
    in {
      inherit dark;
      shadow = "#000000";
      base16 = palette;
      base16Raw = paletteRaw;
      primary = palette.${primaryColor};
      secondary = palette.${secondaryColor};
    };
  };
}
