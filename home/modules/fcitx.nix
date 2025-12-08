{
  pkgs,
  lib,
  ...
}: {
  # Enable Fcitx5
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        qt6Packages.fcitx5-chinese-addons
      ];
      settings = {
        globalOptions.Behavior = {
          ActiveByDefault = true;
          ShareInputState = "All";
        };
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "pinyin";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "keyboard-ru";
          "Groups/0/Items/2".Name = "pinyin";
        };
        addons.quickphrase.sections."TriggerKey"."0" = "Super+E";
      };
    };
  };

  # Set environment variables
  home.sessionVariables = {
    INPUT_METHOD = "fcitx";
    IMSETTINGS_MODULE = "fcitx";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
  };

  # Install fcitx scroll script
  home.packages = with pkgs; [fcitx5-scroll];
}
