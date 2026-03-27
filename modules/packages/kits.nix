# Sets of usefull packages grouped together
{
  self,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    inputs',
    ...
  }: {
    _module.args.packageKits = with pkgs; {
      # Essential system packages
      system = [
        # Hardware
        pkgs.usbutils
        pkgs.pciutils
        # Network
        pkgs.iw
        pkgs.wirelesstools
        pkgs.openssh
        pkgs.openvpn
        pkgs.wget
        pkgs.nmap
        # Userspace
        pkgs.xdg-utils
        pkgs.killall
        # Containers
        pkgs.podman-compose
        pkgs.flatpak
        # Editor
        self'.packages.nixvim
      ];

      # Essential CLI tools
      base-cli = [
        ripgrep # grep
        fd # find
        lsd # ls
        dua # disk usage
        bottom # top alternative
        termdown # terminal countdown
        presenterm # presentations in terminal
        jrnl # CLI journal
        yazi # file manager
        rbw # password manager
        pinentry-tty # password manager dependency
        caligula # ISO imaage writer
        sshpass # ssh with automatic password
        proxychains-ng # Proxy child processes
        self'.packages.fzf # fuzzy finder
        self'.packages.bat # cat alternative
        self'.packages.fastfetch # system info
      ];

      # CLI development tools
      dev-cli = [
        nodejs
        jq # json parser
        quartoMinimal # markdown exporter
        tokei # code lines counter
      ];

      # CLI AI agents
      ai-cli = [
        gemini-cli # ai agent
        shell-gpt # ai shell tool
      ];

      # Essential UI utils
      base-ui = [
        pcmanfm # file-manager
        lxmenu-data # pcmanfm dependency
        shared-mime-info # pcmanfm dependency
        blueman # bluetooth control center
        pwvucontrol # sound control center
        xarchiver # archiver
        gparted # disk manager
        dialect # translator
        chromium # browser
        pinentry-rofi # password picker
      ];

      # Office tools
      office = [
        libreoffice-fresh # office app
        xournalpp # whiteboard
        foliate # book library
        zotero # academic lliterature
        zathura # quick pdf reader
        kdePackages.okular # pdf reader + comments
        drawio # vector editor for schemes
        pdfarranger # pdf editor
      ];

      # Video/Image/Audio tools
      multimedia = [
        nomacs # image viewer
        mpv # video viewer
        qbittorrent # torrents
        inkscape # vector editor
        gimp3 # image editor
        inputs'.hayase.packages.default
      ];

      # UI tools for development
      dev-ui = [
        remmina # ssh, vnc, and rdp client
        bruno # request testing
        ashpd-demo # test XDG portal
        devtoolbox # small usefull tools
        sqlitebrowser # sqlite db browser
        (vscode-fhsWithPackages (ps: with ps; [nodejs_24])) # code editor
      ];

      # Virtualization
      vm = [
        quickemu # virtual machines
        pods # podman ui
      ];

      # Game development tools
      gamedev = [
        blender # 3d editor
        godot # game engine
      ];

      # Windows font pack
      fonts = [
        corefonts
        vista-fonts-chs
        inputs'.wpsoffice-flake.packages.fonts
      ];
    };
  };
}
