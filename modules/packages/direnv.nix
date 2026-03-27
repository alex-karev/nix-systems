# Direnv setup
# TODO
{
  self,
  inputs,
  theme,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.direnv =
      inputs.wrapper-modules.lib.wrapPackage ({...}: {
      });
  };
}
