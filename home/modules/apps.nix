# Apps
# TODO: group
{pkgs, ...}: {
  home.packages = with pkgs;
    [
      pcmanfm
      blueman
      xournalpp
      remmina
      obsidian
      zotero
      pwvucontrol
      zathura
      xarchiver
      bruno
      mpv
      qbittorrent
      foliate
      drawio
      gparted
      nomacs
      ashpd-demo # Test XDG portal
      dialect
      devtoolbox
      blender
      sqlitebrowser
      inkscape
      kdePackages.okular
      pdfarranger
      gimp3
      quickemu
      godot
      zoom-us
      chromium
      zen-browser
      wemeet
      (wechat.override {fakeHome = "~/Data/WeChat";})
      # (wpsoffice.override {scale = "2";})
      libreoffice-fresh
    ]
    ++ [
      corefonts
      vista-fonts-chs
      wpsoffice-fonts
    ];

  # Enable font config
  fonts.fontconfig.enable = true;
}
