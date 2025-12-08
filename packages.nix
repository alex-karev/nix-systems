{
  system,
  inputs,
}: [
  (self: super:
    {
      nixvim = inputs.nixvim.packages.${system}.default;
      wpsoffice = inputs.bubblewrap.packages."${system}".wpsoffice;
      #wemeet = inputs.bubblewrap.packages."${system}".wemeet;
      wechat = inputs.bubblewrap.packages."${system}".wechat;
      wpsoffice-fonts = inputs.bubblewrap.packages."${system}".wpsoffice-fonts;
      firefox-addons = inputs.firefox-addons.packages."${system}";
      zen-browser = inputs.zen-browser.packages."${system}".default;
      nur = inputs.nur.legacyPackages.${system};
      elyprismlauncher = inputs.prismlauncher.packages.${system}.default;
      stremio = inputs.nixohess.packages.${system}.stremio-linux-shell;
    }
    // inputs.scripts.packages."${system}")
]
