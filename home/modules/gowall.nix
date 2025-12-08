{
  pkgs,
  config,
  ...
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
  systemd.user.services.gowall-generate = {
    Unit = {
      Description = "Generate wallpapers using Gowall";
    };

    Service = {
      Type = "oneshot";
      WorkingDirectory = "%h/Pictures/Wallpapers";
      ExecStart = "${pkgs.gowall}/bin/gowall convert --dir %h/Pictures/Wallpapers --output %h/Pictures/gowall -t ${gowallTheme}";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };

  home.file."${config.home.homeDirectory}/Pictures/Wallpapers/default.png" = {
    source = ../../assets/wallpaper.png;
  };
}
