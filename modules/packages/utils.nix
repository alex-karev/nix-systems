# Small tweaks for all kinds of cli utils
{
  self,
  inputs,
  gitUser,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    # Fzf
    packages.fzf = inputs.wrapper-modules.lib.wrapPackage ({...}: {
      inherit pkgs;
      package = pkgs.fzf;
      env = {
        FZF_DEFAULT_OPTS = "--color=16";
      };
    });

    # Bat
    packages.bat = inputs.wrapper-modules.lib.wrapPackage ({...}: {
      inherit pkgs;
      package = pkgs.bat;
      env = {
        BAT_THEME = "Base16";
      };
    });

    # Fuzzel calc
    packages.fuzzel-calc = pkgs.writeShellScriptBin "fuzzel-calc" ''
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
    '';

    # Fastfetch
    packages.fastfetch = inputs.wrapper-modules.lib.wrapPackage ({...}: {
      inherit pkgs;
      package = pkgs.fastfetch;
      flags = {
        "--config" = pkgs.writeText "fastfetch.json" (builtins.toJSON {
          logo = {
            type = "small";
            padding.right = 1;
          };
          display = {
            size.binaryPrefix = "si";
            color = "blue";
            separator = "  ";
          };
          modules = [
            "title"
            "uptime"
            "os"
            "kernel"
            "packages"
            "host"
            "cpu"
            "gpu"
            "memory"
            "disk"
            "display"
            "battery"
            "datetime"
            "break"
            "colors"
          ];
        });
      };
    });
  };
}
