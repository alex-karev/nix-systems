# Common settings for wayland window managers
{
  pkgs,
  config,
  ...
}: {
  # Notifications
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 1300;
      border-radius = 10;
      "app-name=\"Fcitx\"" = {
        invisible = true;
      };
      "app-name=\"Pinyin\"" = {
        invisible = true;
      };
    };
  };

  # Launcher
  programs.fuzzel = {
    enable = true;
    settings.main = {
      terminal = "${pkgs.kitty}/bin/kitty";
    };
  };

  # Terminal
  programs.kitty = {
    enable = true;
  };
  home.sessionVariables = {
    TERMINAL = "kitty";
  };

  # Wallpaper
  services.swww.enable = true;

  # Locker
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      indicator = true;
      timestr = "%I:%M %p";
      datestr = "%b %d %a";
      indicator-x-position = 150;
      effect-vignette = "0.3:0.4";
    };
  };

  # Install fuzzel scripts
  home.packages = with pkgs; [
    fuzzel-battery
    fuzzel-calc
    swww
  ];

  # Networkmanager dmenu dotfile
  home.file.".config/networkmanager-dmenu/config.ini".source = ../../dotfiles/networkmanager_dmenu.ini;
}
