{
  pkgs,
  waybarSignal ? "2",
}: let
  fcitxRemote = "${pkgs.fcitx5}/bin/fcitx5-remote";
in
  pkgs.writeShellScriptBin "fcitx5-scroll" ''
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
  ''
