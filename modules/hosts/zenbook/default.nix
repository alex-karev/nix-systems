{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.zenbook = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.zenbookConfiguration
    ];
  };
}
