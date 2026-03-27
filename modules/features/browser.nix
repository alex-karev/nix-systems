# Browser configurations
{
  self,
  inputs,
  theme,
  ...
}: {
  flake.homeModules.browser = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.zen-browser.homeModules.beta
    ];
    programs.zen-browser = {
      enable = true;
      policies = {
        DisablePocket = true;
        DisableTelemetry = true;
        NoDefaultBookmarks = true;
        DontCheckDefaultBrowser = true;
        OfferToSaveLogins = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        AutofillCreditCardEnabled = false;
      };
      profiles."default" = {
        settings = {
          "extensions.autoDisableScopes" = 0;
          "sidebar.visibility" = "hide-sidebar";
          "zen.view.compact.enable-at-startup" = true;
          "zen.view.compact.toolbar-flash-popup" = true;
          "zen.view.use-single-toolbar" = false;
        };
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          bitwarden
          vimium-c
          foxyproxy-standard
          sponsorblock
        ];
      };
    };
  };
}
