{pkgs}: let
  mkNotify = tag: ''
    ${pkgs.libnotify}/bin/notify-send \
        -h string:x-dunst-stack-tag:${tag} \
        -t 800 \
  '';
  # Play notification sound
  mkSound = sound: ''
    ${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play -i ${sound}
  '';

  # Change volume script
  pamixer = "${pkgs.pamixer}/bin/pamixer";
in
  pkgs.writeShellScriptBin "notify-volume" ''
    #!${pkgs.bash}/bin/bash
    if [[ "$1" == "-i" ]]; then
        ${pamixer} -i $2
    elif [[ "$1" == "-d" ]]; then
        ${pamixer} -d $2
    elif [[ "$1" == "-t" ]]; then
        ${pamixer} -t
    fi
    volume=$(${pamixer} --get-volume-human)
    volumeval=$volume
    icon="󰕾"
    if [[ "$volume" == "muted" ]]; then
      icon="󰖁"
      volumeval=0
    fi
    ${mkNotify "changeVolume"} -h int:value:"$volumeval" "$icon Volume: $volume"
    ${mkSound "audio-volume-change"}

  ''
