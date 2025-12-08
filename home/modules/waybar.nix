{
  pkgs,
  config,
  ...
}: {
  programs.waybar = {
    enable = true;
    style = pkgs.lib.readFile ../../dotfiles/waybar.css;
    settings = {
      mainBar = {
        spacing = 0;
        modules-left = ["niri/workspaces"];
        modules-center = ["clock"];
        modules-right = [
          "battery"
          "network"
          "cpu"
          "memory"
          "temperature"
          "custom/vpn"
          "custom/fcitx5"
        ];

        "niri/workspaces" = {
          "show-special" = false;
          "all-outputs" = false;
          "warp-on-scroll" = true;
          format = "{icon} ";
          "format-icons" = {
            "code" = "";
            "browse" = "";
            "edit" = "";
            "game" = "";
            "media" = "󱜏";
            "social" = "󰭹";
            "read" = "";
            "tweak" = "";
            "9" = "";
            "1" = "󰐨";
            "2" = "";
            "3" = "";
          };
        };

        clock = {
          format = "{:%b %d %a - %I:%M %p}";
          "format-alt" = "{:%b %d %a - %I:%M:%S}";
          tooltip = false;
        };

        cpu = {
          format = "  {usage}%";
          tooltip = false;
        };

        memory.format = "  {}%";

        temperature = {
          "critical-threshold" = 80;
          format = "{icon} {temperatureC}°C";
          "format-icons" = ["" "" ""];
        };

        battery = {
          bat = "BATT";
          interval = 30;
          states = {
            # "good" = 95;
            warning = 30;
            critical = 15;
          };
          "on-click-right" = "${pkgs.fuzzel-battery}/bin/fuzzel-battery";
          format = "{icon} {capacity}%";
          "format-full" = "{icon} {capacity}%";
          "format-charging" = "󰂄 {capacity}%";
          "format-plugged" = " {capacity}%";
          "format-alt" = "{icon} {time}";
          "format-icons" = [
            "󰁺"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰂂"
          ];
        };

        network = {
          format = "󰲛 ";
          "format-wifi" = "󰖩 {signalStrength}%";
          "format-ethernet" = "󰈀 ";
          "format-disconnected" = "󰖪 ";
          "on-click" = "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu";
          "tooltip-format-ethernet" = "{ipaddr}/{cidr}\n󰁝 {bandwidthUpBits} 󰁅 {bandwidthDownBits}";
          "tooltip-format-wifi" = "{essid}: {ipaddr}/{cidr}\n󰁝 {bandwidthUpBits} 󰁅 {bandwidthDownBits}";
        };

        "custom/fcitx5" = let
          cmd = "${pkgs.fcitx5-scroll}/bin/fcitx5-scroll";
        in {
          format = "  <b>{}</b>";
          signal = 2;
          exec = "${cmd} -s";
          "on-click" = "${cmd}";
        };

        "custom/vpn" = let
          cmd = "${pkgs.tsexitnode}/bin/tsexitnode";
        in {
          format = "{icon} ";
          "return-type" = "json";
          "format-icons" = {
            on = "󱇲";
            off = "󰅤";
          };
          signal = 3;
          exec = "${cmd} -j";
          "on-click" = "${cmd} -t";
        };
      };
    };
  };
}
