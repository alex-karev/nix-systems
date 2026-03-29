{inputs, ...}: {
  perSystem = {pkgs, self', ...}: {
    devShells.default = pkgs.mkShell {
      name = "sys";
      packages = with pkgs; [
        self'.packages.git
      ];
    };
  };
}
