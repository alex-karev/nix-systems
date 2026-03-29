{
  self,
  inputs,
  theme,
  ...
}: {
  flake.homeModules.git = {
    pkgs,
    lib,
    ...
  }: {
    programs.git = {
      enable = true;
      lfs.enable = true;
      ignores = [".envrc"];
    };
  };
}
