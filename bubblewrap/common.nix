{pkgs}: {
  name,
  package,
  fakeHome,
  extraBwrapArgs ? [],
  extraInstallCommands ? "",
}: let
  # Define bwrap package
  bwrapPackage = pkgs.bubblewrap;

  # Construct bwrap arguments
  bwrapArgs =
    [
      "--unshare-all"
      "--share-net"
      "--cap-drop ALL"
      "--dev /dev"
      "--dev-bind /dev/dri{,}"
      "--proc /proc"
      "--tmpfs /tmp"
      "--tmpfs /dev/shm"
      "--new-session"
      "--ro-bind /nix/store /nix/store"
      "--ro-bind /etc /etc"
      "--ro-bind /tmp/.X11-unix /tmp/.X11-unix"
      "--bind /run/user/\$(id -u)/bus /run/user/\$(id -u)/bus"
      #"--ro-bind /run/current-system/sw/bin /bin"
      #"--setenv PATH /bin"
    ]
    ++ extraBwrapArgs
    ++ [
      "--bind ${fakeHome} ~"
    ];

  # Define bwrap command
  bwrapCommand = ''
    #!${pkgs.bash}/bin/bash
    mkdir -p ${fakeHome}
    exec ${bwrapPackage}/bin/bwrap ${pkgs.lib.concatStringsSep " " bwrapArgs} ${package}/bin'';

in
  pkgs.stdenv.mkDerivation {
    name = "${name}-sandboxed";
    version =
      if builtins.hasAttr "version" package
      then package.version
      else "1.0";
    dontBuild = true;
    dontUnpack = true;

    # Dependencies
    buildInputs = [
      package
      pkgs.bubblewrap
    ];

    # Generate run scripts and modify .desktop files
    installPhase = ''
      mkdir -p $out/bin
      for file in "${package}/bin"/*; do
        if [ -f "$file" ]; then
          filename=$(basename $file)
          echo "${bwrapCommand}/$filename \"\$@\"" > "$out/bin/$filename"
          chmod +x "$out/bin/$filename"
        fi
      done

      mkdir -p $out/share/applications
      for file in "${package}/share/applications"/*.desktop; do
        if [ -f "$file" ]; then
          newfile="$out/share/applications/$(basename "$file")"
          cp "$file" "$newfile"
          sed -i "s|${package}|$out|g" "$newfile"
        fi
      done
      ${extraInstallCommands}
    '';

    # About package
    meta = {
      description = "Sandboxed ${name} package";
      homepage = "https://github.com/alex-karev/chinese-packages-flake";
    };
  }
