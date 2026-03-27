# Enable fcitx input method
# TODO: make it possible to define IMs on top level
# TODO: convert into options config format
{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.fcitx = {
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
          # TODO: Fix emoji input
          # addons.quickphrase.sections."TriggerKey"."0" = "Super+Shift+E";
        };
      };
    };

    # Set environment variables
    environment.sessionVariables = {
      INPUT_METHOD = "fcitx";
      IMSETTINGS_MODULE = "fcitx";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
    };

    # Install fcitx scroll script
    environment.systemPackages = [self.packages.${pkgs.stdenv.hostPlatform.system}.fcitx5-scroll];
  };

  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: let
    fcitxRemote = "${pkgs.fcitx5}/bin/fcitx5-remote";
    waybarSignal = "2";
  in {
    packages.fcitx5-scroll = pkgs.writeShellScriptBin "fcitx5-scroll" ''
      #!${pkgs.bash}/bin/bash
      layouts=("keyboard-us" "keyboard-ru" "pinyin")
      case "$1" in
        -s|--status)
          ${fcitxRemote} -n | ${pkgs.gawk}/bin/gawk '{
            if ($0=="keyboard-us") print "en";
            else if ($0=="keyboard-ru") print "ru";
            else if ($0=="pinyin") print "cn";
            else print "?"
          }'
          ;;
        "" )
          current=$(${fcitxRemote} -n)
          next_index=0
          for i in "''${!layouts[@]}"; do
            if [[ "''${layouts[$i]}" == "$current" ]]; then
              next_index=$(( (i + 1) % ''${#layouts[@]} ))
              break
            fi
          done
          ${fcitxRemote} -s "''${layouts[$next_index]}"
          ${pkgs.procps}/bin/pkill -RTMIN+${waybarSignal} waybar
          ;;
        * )
          echo "Unknown option: $1"
          echo "Use -s (--status) or empty"
          exit 1
          ;;
      esac
    '';
  };
}
