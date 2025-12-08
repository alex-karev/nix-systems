{
  pkgs,
  config,
  homePath,
  ...
}: let
  # Define packages
  gowall = import ./gowall.nix {inherit pkgs config;};
  wallpaperPack = gowall.mkWallpaperPack ../../assets/wallpapers;
  xwayland-satellite = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
  locker = "${pkgs.swaylock-effects}/bin/swaylock";
  notify-volume = "${pkgs.notify-volume}/bin/notify-volume";
  notify-brightness = "${pkgs.notify-brightness}/bin/notify-brightness";
  fcitx5-scroll = "${pkgs.fcitx5-scroll}/bin/fcitx5-scroll";
  tsexitnode = "${pkgs.tsexitnode}/bin/tsexitnode";
  gradia = "${pkgs.gradia}/bin/gradia";
  screenshotCommand = "${gradia} --screenshot";
  gammastep = "${pkgs.gammastep}/bin/gammastep";
  killall = "${pkgs.procps}/bin/pkill";
  redshift = "${killall} gammastep || ${gammastep} -O 4500";
  fuzzel = "${pkgs.fuzzel}/bin/fuzzel";
  fuzzel-calc = "${pkgs.fuzzel-calc}/bin/fuzzel-calc";
  terminal = "${pkgs.kitty}/bin/kitty";
  bg = "${pkgs.waypaper}/bin/waypaper --folder ${wallpaperPack} --backend swww";
  waybar = "${pkgs.waybar}/bin/waybar";
  networkmanager = "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu";
in {
  # Activate gnome keyringniri
  services.gnome-keyring.enable = true;

  # Activate portals
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    xdgOpenUsePortal = true;
    config = {
      niri = {
        default = ["gtk" "wlr"];
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
        "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
      };
    };
  };

  # Activate niri
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # Setup niri
  programs.niri.settings = {
    # Display settings
    outputs."eDP-1" = {
      position = {
        x = 0;
        y = 0;
      };
      scale = 2.0;
      focus-at-startup = true;
    };

    # Input devices
    input = {
      keyboard.numlock = true;
      touchpad.tap = true;
      touchpad.natural-scroll = false;
      warp-mouse-to-focus.enable = true;
      focus-follows-mouse.max-scroll-amount = "0%";
    };

    # Layout settings
    layout = {
      gaps = 16;
      center-focused-column = "never";
      always-center-single-column = true;
      default-column-width.proportion = 0.5;

      border.width = 3;

      shadow = {
        enable = true;
        softness = 30;
        spread = 5;
        offset = {
          x = 0;
          y = 5;
        };
        color = "#0007";
      };

      tab-indicator = {
        position = "top";
        place-within-column = true;
        corner-radius = 12;
        width = 6;
        gap = 8;
        gaps-between-tabs = 8;
        length.total-proportion= 1.0;
      };

      struts = {
        left = 16;
        right = 16;
      };
    };

    # General
    animations.slowdown = 0.5;
    prefer-no-csd = true;
    screenshot-path = null;
    xwayland-satellite = {
      enable = true;
      path = xwayland-satellite;
    };
    switch-events.lid-close.action.spawn = locker;
    hotkey-overlay = {
      skip-at-startup = true;
      hide-not-bound = true;
    };

    # Environment variables
    environment = {
      XDG_SESSION_DESKTOP = "niri";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    # Workspaces
    workspaces = let
      mkWorkspace = name: {
        inherit name;
        open-on-output = "eDP-1";
      };
    in {
      "01" = mkWorkspace "code";
      "02" = mkWorkspace "browse";
      "03" = mkWorkspace "edit";
      "04" = mkWorkspace "game";
      "05" = mkWorkspace "media";
      "06" = mkWorkspace "social";
      "07" = mkWorkspace "read";
      "08" = mkWorkspace "tweak";
    };

    # Start apps
    spawn-at-startup = [
      #{sh = bg;}
      {argv = [waybar];}
    ];

    # Keybindings
    binds = let
    in
      with config.lib.niri.actions; {
        # Launchers
        "Mod+Shift+Slash".action = show-hotkey-overlay;
        "Mod+Return".action = spawn terminal;
        "Mod+R".action = spawn-sh fuzzel;
        "Mod+S".action = spawn-sh screenshotCommand;
        "Mod+U".action = spawn-sh fuzzel-calc;
        "Ctrl+Space".action = spawn-sh fcitx5-scroll;
        "Mod+Equal".action = spawn-sh redshift;
        "Mod+V".action = spawn-sh "${tsexitnode} -t";
        "Mod+W".action = spawn-sh networkmanager;
        "Mod+B".action = spawn-sh bg;

        # Windows
        "Mod+Tab" = {
          action = toggle-overview;
          repeat = false;
        };
        "Mod+C" = {
          action = close-window;
          repeat = false;
        };
        "Mod+T".action = toggle-window-floating;
        "Mod+F".action = fullscreen-window;
        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+J".action = move-window-down;
        "Mod+Shift+K".action = move-window-up;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;
        "Mod+Shift+Home".action = move-column-to-first;
        "Mod+Shift+End".action = move-column-to-last;
        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;
        "Mod+M".action = maximize-column;
        "Mod+Shift+M".action = expand-column-to-available-width;
        "Mod+Space".action = center-column;
        "Mod+D".action = set-column-width "-10%";
        "Mod+I".action = set-column-width "+10%";
        "Mod+Shift+D".action = set-window-height "-10%";
        "Mod+Shift+I".action = set-window-height "+10%";
        "Mod+Shift+T".action = switch-focus-between-floating-and-tiling;
        "Mod+X".action = toggle-column-tabbed-display;
        "Mod+Escape".action = toggle-keyboard-shortcuts-inhibit;
        "Mod+TouchpadScrollUp".action = focus-window-up;
        "Mod+TouchpadScrollDown".action = focus-window-down;

        # Workspaces
        "Mod+Right".action = focus-workspace-down;
        "Mod+Left".action = focus-workspace-up;
        "Mod+Shift+Right".action = move-column-to-workspace-down;
        "Mod+Shift+Left".action = move-column-to-workspace-up;
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;
        "Mod+Shift+1".action."move-window-to-workspace" = 1;
        "Mod+Shift+2".action ."move-window-to-workspace" = 2;
        "Mod+Shift+3".action ."move-window-to-workspace" = 3;
        "Mod+Shift+4".action ."move-window-to-workspace" = 4;
        "Mod+Shift+5".action ."move-window-to-workspace" = 5;
        "Mod+Shift+6".action ."move-window-to-workspace" = 6;
        "Mod+Shift+7".action ."move-window-to-workspace" = 7;
        "Mod+Shift+8".action ."move-window-to-workspace" = 8;
        "Mod+Shift+9".action ."move-window-to-workspace" = 9;

        # Monitors
        "Mod+Up".action = focus-monitor-next;
        "Mod+Down".action = focus-monitor-previous;
        "Mod+Shift+Up".action = move-window-to-monitor-next;
        "Mod+Shift+Down".action = move-window-to-monitor-previous;
        "Mod+Ctrl+Up".action = move-workspace-to-monitor-next;
        "Mod+Ctrl+Down".action = move-workspace-to-monitor-previous;

        # Volume and Brightness
        "XF86AudioRaiseVolume".action = spawn-sh "${notify-volume} -i 5";
        "Mod+F3".action = spawn-sh "${notify-volume} -i 5";
        "XF86AudioLowerVolume".action = spawn-sh "${notify-volume} -d 5";
        "Mod+F2".action = spawn-sh "${notify-volume} -d 5";
        "XF86AudioMute".action = spawn-sh "${notify-volume} -t";
        "Mod+F1".action = spawn-sh "${notify-volume} -t";
        "XF86MonBrightnessUp".action = spawn-sh "${notify-brightness} -inc 5";
        "Mod+F5".action = spawn-sh "${notify-brightness} -inc 5";
        "XF86MonBrightnessDown".action = spawn-sh "${notify-brightness} -dec 5";
        "Mod+F4".action = spawn-sh "${notify-brightness} -dec 5";

        # Session
        "Mod+Q".action = spawn locker;
        "Mod+Shift+Q".action = quit;
        "Mod+Ctrl+Q".action = power-off-monitors;
      };

    # Window rules
    window-rules = let
      matchIds = strings: map (s: {app-id = s;}) strings;
      matchTitles = strings: map (s: {title = s;}) strings;
      mkWorkspaceRule = name: matches: {
        inherit matches;
        open-on-workspace = name;
      };
    in [
      # Enable rounded corners
      {
        geometry-corner-radius = let
          radius = 12.0;
        in {
          top-left = radius;
          top-right = radius;
          bottom-left = radius;
          bottom-right = radius;
        };
        clip-to-geometry = true;
      }

      # Floating windows
      {
        matches =
          [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ]
          ++ matchIds [
            "be.alexandervanhee.gradia$"
            "app.drey.Dialect$"
            "waypaper$"
            "com.github.hluk.copyq$"
            "(.*)(deepl.com)(.*)$"
          ]
          ++ matchTitles [
            "^10.10.9.9_/$"
          ];
        open-floating = true;
        max-height = 800;
      }

      # Workspace 1: code
      (mkWorkspaceRule "code" (matchIds [
        "^(Code|code-oss)$"
        "(.*)(quillbot.com)(.*)"
        "(.*)(overleaf.com)(.*)"
        "(.*)(n8n)(.*)"
        "libreoffice-calc"
        "com.github.xournalpp.xournalpp"
      ]))

      # Workspace 2: browse
      (mkWorkspaceRule "browse" (matchIds [
        "^(firefox|chinesenad|Chromium|Chromium-browser)$"
      ]))

      # Workspace 3: edit
      (mkWorkspaceRule "edit" (matchIds [
        "(gimp-)(.*)"
        "(.*)(figma.com)(.*)"
        "(.*)(www.photopea.com)(.*)"
        "Darktable"
        "krita"
        "photopea"
        "Aseprite"
        "org.inkscape.Inkscape"
        "kdenlive"
        "Cinelerra"
        "Blender"
        "Audacity"
        "draw.io"
        "Blockbench"
        "libreoffice-impress"
      ]))

      # Workspace 4: game
      (mkWorkspaceRule "game" (matchIds [
        "Godot"
        "UnityHub"
        "Lutris"
        "com.github.tkashkin.gamehub"
        "steam"
        "itch"
        "org.polymc.PolyMC"
        "page.kramo.Cartridges"
      ]))

      # Workspace 5: media
      (mkWorkspaceRule "media" (matchIds [
        "mpv"
        "Stremio"
        "FreeTube"
        "netease-cloud-music"
        "YouTube Music"
        "(.*)(music.youtube.com)(.*)"
        "fluent-reader"
      ]))

      # Workspace 6: social
      (mkWorkspaceRule "social" (matchIds [
        "discord"
        "electronic-wechat"
        "wechat"
        "org.telegram.desktop"
        "(.*)(chatgpt.com)(.*)"
        "(.*)(perplexity.ai)(.*)"
        "(.*)(fgpt.duckdns.org)(.*)"
        "(.*)(chat.deepseek.com)(.*)"
        "(.*)(whatsapp.com)(.*)"
        "(.*)(web.telegram.org)(.*)"
        "xyz.chatboxapp.app"
      ]))

      # Workspace 7: read
      (mkWorkspaceRule "read" (matchIds [
        "calibre"
        "obsidian"
        "Zotero"
        "Wps"
        "Et"
        "Wpp"
        "Evince"
        "Komikku"
        "libreoffice-writer"
        "org.kde.okular"
      ]))

      # Workspace 8: tweak
      (mkWorkspaceRule "tweak" (matchIds [
        "uget-gtk"
        "com.obsproject.Studio"
        "webapp-manager.py"
        "org.qbittorrent.qBittorrent"
      ]))

      # Workspace 9: server
      (mkWorkspaceRule "9" (matchIds [
        "Virt-manager"
        "Vmplayer"
        "scrcpy"
        "org.remmina.Remmina"
      ]))
    ];
  };
}
