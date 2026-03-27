{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.direnv = {
    pkgs,
    lib,
    ...
  }: {
    # TODO: turn into a package
    programs.direnv = {
      enable = true;
      silent = true;
      # Link envs to ~/Profiles
      direnvrcExtra = ''
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
    };
  };
}
