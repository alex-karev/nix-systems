{
  pkgs,
  lib,
  enableNotifications ? true,
  waybarSignal ? "3",
  exitNode ? "100.119.173.2", # TODO: change to env var (current: tailscale node)
}: let
  tailscale = "${pkgs.tailscale}/bin/tailscale";
in
  pkgs.writeShellScriptBin "tsexitnode" ''
    #!{pkgs.bash}/bin/bash

    get_status() {
      if ${tailscale} exit-node list | ${pkgs.gnugrep}/bin/grep -qF selected; then
        echo "on"
      else
        echo "off"
      fi
    }

    toggle() {
      local status
      status=$(get_status)
      if [[ "$status" == "on" ]]; then
        ${tailscale} set --exit-node=
        status="off"
      else
        ${tailscale} set --exit-node-allow-lan-access=true --exit-node=${exitNode}
        status="on"
      fi
      pkill -RTMIN+${waybarSignal} waybar
      echo $status
      local ipinfo
      ipinfo=$(${pkgs.curl}/bin/curl -s https://ipinfo.io | ${pkgs.jq}/bin/jq -r "\"VPN: $status\nIP: \(.ip)\nISP: \(.org)\nLocation: \(.city), \(.region), \(.country)\" ")
      ${lib.optionalString enableNotifications "${pkgs.libnotify}/bin/notify-send -i network-vpn -h string:x-dunst-stack-tag:tailscaleExitNode -t 3000 \"$ipinfo\""}
    }

    print_json() {
      local status
      status=$(get_status)
      ${pkgs.jq}/bin/jq -n --compact-output \
        --arg alt "$status" \
        '{alt: $alt}'
    }

    case "$1" in
      -t|--toggle)
        toggle
        ;;
      -j|--json)
        print_json
        ;;
      "" )
        get_status
        ;;
      * )
        echo "Unknown option: $1" >&2
        exit 1
        ;;
    esac
  ''
