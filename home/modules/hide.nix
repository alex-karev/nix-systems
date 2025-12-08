# Hide desktop icons
let
  hideDesktopEntry = {
    name = "Hidden";
    exec = "echo 0";
    noDisplay = true;
  };
in {
  xdg.desktopEntries = {
    "fish" = hideDesktopEntry;
    "blueman-adapters" = hideDesktopEntry;
    "cups" = hideDesktopEntry;
    "org.fcitx.fcitx5-config-qt" = hideDesktopEntry;
    "org.fcitx.Fcitx5" = hideDesktopEntry;
    "org.fcitx.fcitx5-migrator" = hideDesktopEntry;
    "org.gnome.ColorProfileViewer" = hideDesktopEntry;
    "rygel" = hideDesktopEntry;
    "rygel-preferences" = hideDesktopEntry;
    "kbd-layout-viewer5" = hideDesktopEntry;
    "fcitx5-configtool" = hideDesktopEntry;
    "kcm_fcitx5" = hideDesktopEntry;
    "networkmanager_dmenu" = hideDesktopEntry;
    "bottom" = hideDesktopEntry;
    "yazi" = hideDesktopEntry;
    "qt5ct" = hideDesktopEntry;
    "qt6ct" = hideDesktopEntry;
    "kvantummanager" = hideDesktopEntry;
  };
}
