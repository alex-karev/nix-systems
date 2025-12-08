{pkgs, ...}: {
  programs.librewolf = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = {
        # Enable all extension
        "extensions.autoDisableScopes" = 0;
        # Privacy
        "webgl.disabled" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
        #"privacy.resistFingerprinting" = true;
        # Set search
        "browser.search.defaultenginename" = "google";
        "browser.search.order.1" = "google";
        # Disable bookmarks toolbar
        "browser.toolbars.bookmarks.visibility" = "never";
        # Enable themes
        "widget.gtk.ignore-bogus-leave-notify" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      search = {
        force = true;
        default = "dgoogle";
        order = ["dgoogle"];
        engines.dgoogle = {
          name = "Google";
          urls = [
            {
              template = "https://www.google.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };
      };
      userChrome = ../../dotfiles/userChrome.css;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        surfingkeys
        bitwarden
        sponsorblock
        userchrome-toggle-extended
        sidebery
      ];
    };
  };
}
