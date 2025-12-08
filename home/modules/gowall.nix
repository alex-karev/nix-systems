{
  pkgs,
  config,
}: let
  # Write gowall theme
  gowallTheme = pkgs.writeText "stylix-gowall-theme.json" (builtins.toJSON {
    name = "stylix";
    colors = with config.lib.stylix.colors.withHashtag; [
      base00
      base01
      base02
      base03
      base04
      base05
      base06
      base07
      base08
      base09
      base0A
      base0B
      base0C
      base0D
      base0E
      base0F
    ];
  });
in {
  # Generate wallpaper
  mkWallpaper = src: let
    wallpaperPath =
      pkgs.runCommand "gowall-wallpaper" {
        inherit src;
        buildInputs = [pkgs.gowall];
        HOME = "$TMPDIR";
      } ''
        mkdir -p $out
        gowall convert $src --output $out/wallpaper.png -t ${gowallTheme}
      '';
  in "${wallpaperPath}/wallpaper.png";
  # Generate wallpaper pack
  mkWallpaperPack = src:
    pkgs.runCommand "gowall-wallpaper" {
      inherit src;
      buildInputs = [pkgs.gowall];
      HOME = "$TMPDIR";
    } ''
      mkdir -p $out
      gowall convert --dir $src --output $out -t ${gowallTheme}
    '';
  # Apply colors to icon theme
  # TODO: This will not work
  # See: https://achno.github.io/gowall-docs/conversions/convertIconTheme/
  mkIcons = iconPackage:
    pkgs.runCommand "gowall-icons" {
      buildInputs = [
        iconPackage
        pkgs.gowall
      ];
      HOME = "$TMPDIR";
    } ''
      mkdir -p $out/share/icons
      gowall convert --dir ${iconPackage}/share/icons --output $out/share/icons -t ${gowallTheme}
    '';
}
