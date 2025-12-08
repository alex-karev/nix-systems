{pkgs}: let
in
  pkgs.writeShellScriptBin "fuzzel-calc" ''
    #!${pkgs.bash}/bin/bash
    LAST=""
    while true; do
      [ -z "$LAST" ] && SPACE=" "
      NEXT="$(${pkgs.fuzzel}/bin/fuzzel -l 0 --dmenu -p "''${LAST}''${SPACE}")"
      # Quit if empty
      [ -z "$NEXT" ] && exit 1
      [ "$NEXT" = "y" ] && ${pkgs.wl-clipboard}/bin/wl-copy "$LAST" && exit 0
      LAST="$(echo "$LAST$NEXT" | ${pkgs.bc}/bin/bc -l | ${pkgs.gnused}/bin/sed '/\./ s/\.\{0,1\}0\{1,\}$//')"
    done
  ''
