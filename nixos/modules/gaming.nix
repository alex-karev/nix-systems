{
  pkgs,
  lib,
  ...
}: let
  # Steam-run wrapper scipt
  mkSteamWrapScript = file: ''
    #!${pkgs.bash}/bin/bash
    exec steam-run ${file} \"\$@\"
  '';

  # Wrapper for using other packages via steam-run
  mkSteamWrapper = package:
    pkgs.stdenv.mkDerivation {
      name = "${package}-steam-run";
      version = package.version or null;
      dontBuild = true;
      dontUnpack = true;
      buildInputs = [package];
      installPhase = ''
        mkdir -p $out/bin
        for file in "${package}/bin"/*; do
          if [ -f "$file" ]; then
            newfile="$out/bin/$(basename "$file")"
            echo "${mkSteamWrapScript "$file"}" > $newfile
            chmod +x $newfile
          fi
        done
        mkdir -p $out/share/applications
        if [ -d "${package}/share/icons" ]; then
          cp -rL "${package}/share/icons" "$out/share/icons"
        fi
        for file in ${package}/share/applications/*.desktop; do
          if [ -f "$file" ]; then
            newfile="$out/share/applications/$(basename "$file")"
            sed "s|${package}|$out|g" "$file" > "$newfile"
          fi
        done
      '';
    };
in {
  # Enable steam
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraBwrapArgs = [
        "--bind ~/Data/Games ~" # Isolate games
        "--bind ~/Data/Games ~/Data/Games" # Fix xdg-open
        "--bind ~/.local/share/bottles ~/.local/share/bottles" # Fix bottles paths
      ];
    };
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Xbox gamepad
  hardware.xone.enable = true;

  # Install packages
  environment.systemPackages = with pkgs; [
    (mkSteamWrapper bottles)
    (mkSteamWrapper elyprismlauncher)
    (mkSteamWrapper stremio)
    (mkSteamWrapper discord)
    (mkSteamWrapper cartridges)
  ];
}
