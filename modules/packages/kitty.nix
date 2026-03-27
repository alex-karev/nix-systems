{
  self,
  inputs,
  theme,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    # Kitty config
    packages.kitty = inputs.wrapper-modules.lib.wrapPackage ({
      config,
      wlib,
      lib,
      ...
    }: let
      settings = with theme;
      with theme.colors.base16; {
        # Fonts
        font_family = fonts.family.mono;
        font_size = fonts.size.terminal;

        # Colors
        foreground = base05;
        background = base00;
        selection_foreground = base00;
        selection_background = base05;

        # Cursor colors
        cursor = base05;
        cursor_text_color = base00;
        cursor_trail_color = "none";

        # URL underline color when hovering with mouse
        url_color = base0D;

        # kitty window border colors and terminal bell colors
        active_border_color = base0D;
        inactive_border_color = base03;
        bell_border_color = base08;
        visual_bell_color = "none";

        # OS Window titlebar colors
        wayland_titlebar_color = "system";
        macos_titlebar_color = "system";

        # Tab bar colors
        active_tab_foreground = base00;
        active_tab_background = base0D;
        inactive_tab_foreground = base05;
        inactive_tab_background = base01;
        tab_bar_background = "none";
        tab_bar_margin_color = "none";

        # Colors for marks (marked text in the terminal)
        mark1_foreground = base00;
        mark1_background = base0D;
        mark2_foreground = base00;
        mark2_background = base0E;
        mark3_foreground = base00;
        mark3_background = base0F;

        # The basic 16 colors
        color0 = base00;
        color8 = base03;
        color1 = base08;
        color9 = base08;
        color2 = base0B;
        color10 = base0B;
        color3 = base0A;
        color11 = base0A;
        color4 = base0D;
        color12 = base0D;
        color5 = base0E;
        color13 = base0E;
        color6 = base0C;
        color14 = base0C;
        color7 = base05;
        color15 = base07;
      };
    in {
      inherit pkgs;
      package = pkgs.kitty;
      flags = {
        "--config" =
          pkgs.writeText "kitty.conf"
          (lib.concatStringsSep "\n"
            (lib.mapAttrsToList (k: v: "${k} ${v}") settings));
      };
      flagSeparator = "=";
    });
  };
}
