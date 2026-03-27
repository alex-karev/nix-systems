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
    packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      # Dumped using `noctalia-shell ipc call state all` command
      settings =
        (builtins.fromJSON
          (builtins.readFile ./noctalia.json)).settings;

      # Assign colors
      colors = with theme.colors; with base16; {
        mOnError = base00; # background
        mOnPrimary = base00; # background
        mOnHover = base00; # background
        mOnSecondary = base00; # background
        mOnSurface = base06; # foreground
        mOnSurfaceVariant = base05; # comments
        mOnTertiary = base00; # background
        mOutline = base02; # selection
        mError = base08; # red
        mPrimary = primary;
        mHover = secondary;
        mSecondary = secondary;
        mShadow = shadow;
        mSurface = base00; # background
        mSurfaceVariant = base01; # selection bg
        mTertiary = base0D; # blue
      };
    };
  };
}
