{
  pkgs,
  config,
  lib,
  hostname,
  homePath,
  systemPath,
  droidPath,
  ...
}: {
  # Add essential shell applications
  home.packages = with pkgs; [
    killall
    unzip
    wget
    openssh
    ripgrep # grep
    fd # find
    lsd # ls
    jq # json parser
    dua # disk usage
    bottom # top alternative
    termdown # terminal countdown
    pciutils # lspci and etc.
    tokei # code lines counter
    yazi # file manager
    presenterm # presentations in terminal
    jrnl # CLI journal
    quartoMinimal # markdown exporter
    gemini-cli # ai agent
    #(nixvim.extend (config.lib.stylix.nixvim.config or {}))
    (nixvim.extend config.stylix.targets.nixvim.exportedModule)
    texliveMedium # TODO: delete

    # Fish plugins
    fishPlugins.done
    fishPlugins.forgit
    fishPlugins.grc
    grc
  ];

  # Add env variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Enable ssh agent
  services.ssh-agent.enable = true;

  # Set shell apps
  programs.bat.enable = true;
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
        padding.right = 1;
      };
      display = {
        size.binaryPrefix = "si";
        color = "blue";
        separator = "  ";
      };
      modules = [
        "title"
        "uptime"
        "os"
        "kernel"
        "packages"
        "host"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "display"
        "battery"
        "datetime"
        "break"
        "colors"
      ];
    };
  };

  # Direnv for automatic dev environments and gc roots
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };
  home.file.".config/direnv/direnvrc".text = ''
    declare -A direnv_layout_dirs
      direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(sha1sum - <<< "$PWD" | head -c10)"
              path="$(basename "$PWD" | sed 's/[^a-zA-Z0-9]/-/g')"
              mkdir -p ''${HOME}/Profiles
              echo "''${HOME}/Profiles/''${path}-direnv-''${hash}"
          )}"
      }
  '';

  # Enable git
  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [".envrc"];
  };

  # Set fish shell
  programs.fish = let
    # Aliases
    shellAbbrs = {
      cat = "bat -p";
      find = "fd";
      grep = "rg";
      ls = "lsd";
      ncdu = "dua";
      develop = "nix develop -c $SHELL";
      home-update = "home-manager switch --flake ${homePath}#${hostname}";
      droid-update = lib.mkIf (droidPath != null) "nix-on-droid switch --flake ${droidPath}#{hostname}";
      nixos-update = lib.mkIf (systemPath != null) "sudo nixos-rebuild switch --flake ${systemPath}#${hostname}";
      gcroots = "sudo nix-store --gc --print-roots | egrep -v \"^(/nix/var|/run/\\w+-system|\\{memory|/proc)\" | awk -F' -> ' '{print $1}'";
    };

    # Settings
    settings = {
      fish_greeting = "";
      fish_autosuggestion_enabled = "1";
      fish_autosuggestion_color = "brblack";
      fish_history_limit = "10000";
      fish_cd_root_reminder = "false";
      fish_color_valid_path = "blue";
      fish_color_param = "green";
    };

    # Keybindings
    keybindings = {
    };

    # Additonal commands
    init = ''
      set -x _ZO_ECHO '1'
      zoxide init fish | source
      if test -f ~/.local-env.fish
        source ~/.local-env.fish
      end
      functions -e fish_command_not_found
    '';

    # PS1
    prompt = ''
      function fish_prompt
        set_color red
        echo -n "$USER "
        if set -q IN_NIX_SHELL
            set_color cyan
            if set -q name
                echo -n "($name) "
            else
                echo -n "(nix) "
            end
        end
        set_color brblack
        if test (pwd) = $HOME
            echo -n '~'
        else
            echo -n (basename (pwd))
        end
        set_color red
        echo -n " > "
        set_color normal
      end
    '';
  in {
    enable = true;

    # Configure shell
    interactiveShellInit =
      lib.concatStringsSep "\n"
      (
        [prompt]
        ++ (lib.mapAttrsToList (
            name: value: "set -g ${name} ${value}"
          )
          settings)
        ++ (lib.mapAttrsToList (
            name: value: "bind ${name} ${value}"
          )
          keybindings)
        ++ [init]
      );

    # Custom aliases
    shellAbbrs = shellAbbrs;
  };
}
