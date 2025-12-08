{pkgs}: let
  brightnessctl = "sudo ${pkgs.brightnessctl}/bin/brightnessctl";
  mkNotify = tag: ''
    ${pkgs.libnotify}/bin/notify-send \
        -h string:x-dunst-stack-tag:${tag} \
        -t 800 \
  '';
in
  pkgs.writeShellScriptBin "notify-brightness" ''
    #!${pkgs.bash}/bin/bash
    max_brightness=$(${brightnessctl} m)
    brightness_step=$(echo "scale=2; $max_brightness/100*$2" | ${pkgs.bc}/bin/bc)
    brightness_step=$(printf "%.0f" $brightness_step)

    if [[ "$1" == "-inc" ]]; then
        ${brightnessctl} s $brightness_step+
    elif [[ "$1" == "-dec" ]]; then
        ${brightnessctl} s $brightness_step-
    elif [[ "$1" == "-set" ]]; then
        ${brightnessctl} s $brightness_step
    fi

    brightness=$(${brightnessctl} g)
    brightness=$(echo "scale=2; 100/$max_brightness*$brightness" | ${pkgs.bc}/bin/bc)
    brightness=$(printf "%.0f" $brightness)

    icon="󰃞 "

    ${mkNotify "changeBrightness"} -h int:value:"$brightness" "$icon Brightness: $brightness"
  ''
