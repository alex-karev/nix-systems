# Configure niri WM as a package and a module
{
  self,
  inputs,
  theme,
  ...
}: {
  # Add package
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = let
        # Default apps
        noctalia = lib.getExe self'.packages.noctalia;
        actions = let
          terminal = lib.getExe self'.packages.kitty;
        in {
          inherit noctalia;
          inherit terminal;
          language = lib.getExe self'.packages.fcitx5-scroll;
          # language = "${noctalia} ipc call cb language-switch";
          screenshoot = "${lib.getExe pkgs.gradia} --screenshot";
          calc = lib.getExe self'.packages.fuzzel-calc;
          fileManager = "${terminal} -- ${lib.getExe pkgs.yazi}";
          runner = "${noctalia} ipc call launcher toggle";
          lock = "${noctalia} ipc call lockScreen lock";
          redshift = "${noctalia} ipc call nightLight toggle";
          volume-up = "${noctalia} ipc call volume increase";
          volume-down = "${noctalia} ipc call volume decrease";
          mute = "${noctalia} ipc call volume muteOutput";
          brightness-up = "${noctalia} ipc call brightness increase";
          brightness-down = "${noctalia} ipc call brightness decrease";
        };
      in {
        # Autostart
        spawn-at-startup = [
          noctalia
        ];

        # Display settings
        outputs."eDP-1" = {
          position._attrs = {
            x = 0;
            y = 0;
          };
          scale = 2.0;
          focus-at-startup = null;
        };

        # Input devices
        input = {
          mod-key-nested = "Alt";
          keyboard.numlock = null;
          touchpad.tap = null;
          warp-mouse-to-focus = null;
          # focus-follows-mouse.max-scroll-amount = "0%";
        };

        # Layout settings
        layout = {
          gaps = 16;
          center-focused-column = "never";
          always-center-single-column = null;
          default-column-width.proportion = 0.5;
          background-color = theme.colors.base16.base00;

          focus-ring.off = null;

          border = {
            width = 3;
            active-color = theme.colors.primary;
            inactive-color = theme.colors.base16.base02;
            urgent-color = theme.colors.base16.base08;
          };

          shadow = {
            softness = 30;
            spread = 5;
            offset._attrs = {
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
            length._attrs.total-proportion = 1.0;
            active-color = theme.colors.primary;
            inactive-color = theme.colors.base16.base03;
            urgent-color = theme.colors.base16.base08;
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
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        switch-events.lid-close.spawn = actions.lock;
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
        # workspaces = {
        #   "1".open-on-output = "eDP-1";
        #   "2".open-on-output = "eDP-1";
        #   "3".open-on-output = "eDP-1";
        #   "4".open-on-output = "eDP-1";
        #   "5".open-on-output = "eDP-1";
        #   "6".open-on-output = "eDP-1";
        #   "7".open-on-output = "eDP-1";
        #   "8".open-on-output = "eDP-1";
        # };

        # Keybindings
        binds = {
          # Launchers
          # TODO: Fix missing
          "Mod+Shift+Slash".show-hotkey-overlay = null;
          "Mod+Return".spawn-sh = actions.terminal;
          "Mod+R".spawn-sh = actions.runner;
          "Mod+S".spawn-sh = actions.screenshoot;
          "Mod+U".spawn-sh = actions.calc;
          "Mod+Z".spawn-sh = actions.fileManager;
          "Ctrl+Space".spawn-sh = actions.language;
          "Mod+Equal".spawn-sh = actions.redshift;
          # "Mod+V".spawn-sh = "${actions.tsexitnode} -t";
          # "Mod+P".spawn-sh = actions.passwordManager;

          # Windows
          "Mod+Tab" = {
            toggle-overview = null;
            _attrs.repeat = false;
          };
          "Mod+C" = {
            close-window = null;
            _attrs.repeat = false;
          };
          "Mod+T".toggle-window-floating = null;
          "Mod+F".fullscreen-window = null;
          "Mod+H".focus-column-left = null;
          "Mod+J".focus-window-down = null;
          "Mod+K".focus-window-up = null;
          "Mod+L".focus-column-right = null;
          "Mod+Shift+H".move-column-left = null;
          "Mod+Shift+J".move-window-down = null;
          "Mod+Shift+K".move-window-up = null;
          "Mod+Shift+L".move-column-right = null;
          "Mod+Home".focus-column-first = null;
          "Mod+End".focus-column-last = null;
          "Mod+Shift+Home".move-column-to-first = null;
          "Mod+Shift+End".move-column-to-last = null;
          "Mod+BracketLeft".consume-or-expel-window-left = null;
          "Mod+BracketRight".consume-or-expel-window-right = null;
          "Mod+M".maximize-column = null;
          "Mod+Shift+M".expand-column-to-available-width = null;
          "Mod+Space".center-column = null;
          "Mod+D".set-column-width = "-10%";
          "Mod+I".set-column-width = "+10%";
          "Mod+Shift+D".set-window-height = "-10%";
          "Mod+Shift+I".set-window-height = "+10%";
          "Mod+Shift+T".switch-focus-between-floating-and-tiling = null;
          "Mod+X".toggle-column-tabbed-display = null;
          "Mod+Escape".toggle-keyboard-shortcuts-inhibit = null;
          "Mod+TouchpadScrollUp".focus-window-up = null;
          "Mod+TouchpadScrollDown".focus-window-down = null;

          # Workspaces
          "Mod+Right".focus-workspace-down = null;
          "Mod+Left".focus-workspace-up = null;
          "Mod+Shift+Right".move-column-to-workspace-down = null;
          "Mod+Shift+Left".move-column-to-workspace-up = null;
          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;
          "Mod+Shift+1".move-window-to-workspace = 1;
          "Mod+Shift+2".move-window-to-workspace = 2;
          "Mod+Shift+3".move-window-to-workspace = 3;
          "Mod+Shift+4".move-window-to-workspace = 4;
          "Mod+Shift+5".move-window-to-workspace = 5;
          "Mod+Shift+6".move-window-to-workspace = 6;
          "Mod+Shift+7".move-window-to-workspace = 7;
          "Mod+Shift+8".move-window-to-workspace = 8;
          "Mod+Shift+9".move-window-to-workspace = 9;

          # Volume and Brightness
          "XF86AudioRaiseVolume".spawn-sh = actions.volume-up;
          "Mod+F3".spawn-sh = actions.volume-up;
          "XF86AudioLowerVolume".spawn-sh = actions.volume-down;
          "Mod+F2".spawn-sh = actions.volume-down;
          "XF86AudioMute".spawn-sh = actions.mute;
          "Mod+F1".spawn-sh = actions.mute;
          "XF86MonBrightnessUp".spawn-sh = actions.brightness-up;
          "Mod+F5".spawn-sh = actions.brightness-up;
          "XF86MonBrightnessDown".spawn-sh = actions.brightness-down;
          "Mod+F4".spawn-sh = actions.brightness-down;

          # Monitors
          "Mod+Up".focus-monitor-next = null;
          "Mod+Down".focus-monitor-previous = null;
          "Mod+Shift+Up".move-window-to-monitor-next = null;
          "Mod+Shift+Down".move-window-to-monitor-previous = null;
          "Mod+Ctrl+Up".move-workspace-to-monitor-next = null;
          "Mod+Ctrl+Down".move-workspace-to-monitor-previous = null;

          # Session
          "Mod+Q".spawn-sh = actions.lock;
          "Mod+Shift+Q".quit = null;
          "Mod+Ctrl+Q".power-off-monitors = null;
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
            in [radius radius radius radius];
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

          # # Workspace 1: code
          # (mkWorkspaceRule "1" (matchIds [
          #   "^(Code|code-oss)$"
          #   "(.*)(quillbot.com)(.*)"
          #   "(.*)(overleaf.com)(.*)"
          #   "(.*)(n8n)(.*)"
          #   "libreoffice-calc"
          #   "com.github.xournalpp.xournalpp"
          # ]))
          #
          # # Workspace 2: browse
          # (mkWorkspaceRule "2" (matchIds [
          #   "^(firefox|chinesenad|Chromium|Chromium-browser)$"
          # ]))
          #
          # # Workspace 3: edit
          # (mkWorkspaceRule "3" (matchIds [
          #   "(gimp-)(.*)"
          #   "(.*)(figma.com)(.*)"
          #   "(.*)(www.photopea.com)(.*)"
          #   "Darktable"
          #   "krita"
          #   "photopea"
          #   "Aseprite"
          #   "org.inkscape.Inkscape"
          #   "kdenlive"
          #   "Cinelerra"
          #   "Blender"
          #   "Audacity"
          #   "draw.io"
          #   "Blockbench"
          #   "libreoffice-impress"
          # ]))
          #
          # # Workspace 4: game
          # (mkWorkspaceRule "4" (matchIds [
          #   "Godot"
          #   "UnityHub"
          #   "Lutris"
          #   "com.github.tkashkin.gamehub"
          #   "steam"
          #   "itch"
          #   "org.polymc.PolyMC"
          #   "page.kramo.Cartridges"
          # ]))
          #
          # # Workspace 5: media
          # (mkWorkspaceRule "5" (matchIds [
          #   "mpv"
          #   "Stremio"
          #   "FreeTube"
          #   "netease-cloud-music"
          #   "YouTube Music"
          #   "(.*)(music.youtube.com)(.*)"
          #   "fluent-reader"
          # ]))
          #
          # # Workspace 6: social
          # (mkWorkspaceRule "6" (matchIds [
          #   "discord"
          #   "electronic-wechat"
          #   "wechat"
          #   "org.telegram.desktop"
          #   "(.*)(chatgpt.com)(.*)"
          #   "(.*)(perplexity.ai)(.*)"
          #   "(.*)(fgpt.duckdns.org)(.*)"
          #   "(.*)(chat.deepseek.com)(.*)"
          #   "(.*)(whatsapp.com)(.*)"
          #   "(.*)(web.telegram.org)(.*)"
          #   "xyz.chatboxapp.app"
          # ]))
          #
          # # Workspace 7: read
          # (mkWorkspaceRule "7" (matchIds [
          #   "calibre"
          #   "obsidian"
          #   "Zotero"
          #   "Wps"
          #   "Et"
          #   "Wpp"
          #   "Evince"
          #   "Komikku"
          #   "libreoffice-writer"
          #   "org.kde.okular"
          # ]))
          #
          # # Workspace 8: tweak
          # (mkWorkspaceRule "8" (matchIds [
          #   "uget-gtk"
          #   "com.obsproject.Studio"
          #   "webapp-manager.py"
          #   "org.qbittorrent.qBittorrent"
          # ]))
          #
          # # Workspace 9: server
          # (mkWorkspaceRule "9" (matchIds [
          #   "Virt-manager"
          #   "Vmplayer"
          #   "scrcpy"
          #   "org.remmina.Remmina"
          # ]))
        ];
      };
    };
  };

  # Niri module
  flake.nixosModules.niri = {
    pkgs,
    lib,
    ...
  }: {
    # Activate niri
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };

    # Add noctalia to path
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia
    ];

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
          default = lib.mkForce ["gtk" "wlr"];
          "org.freedesktop.impl.portal.Access" = "gtk";
          "org.freedesktop.impl.portal.Notification" = "gtk";
          "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
          "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
          "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
        };
      };
    };
  };
}
