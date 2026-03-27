# NuShell configuration
# TODO: Add nixos update alias, add sgpt integration
# TODO: Fix direnv /etc on non-linux
{
  self,
  inputs,
  systemFlakePath,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    system = pkgs.stdenv.hostPlatform.system;
    starshipConfig = self.packages.${system}.starshipConfig;
  in {
    packages.nushell = inputs.wrapper-modules.wrappers.nushell.wrap {
      inherit pkgs;
      extraPackages = [pkgs.zoxide];
      "env.nu".content = ''
        mkdir ($nu.data-dir | path join "vendor/autoload")
        ${lib.getExe pkgs.zoxide} init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
        ${lib.getExe pkgs.starship} init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
      '';
      "config.nu".content = ''
        # Settings
        $env.config.buffer_editor = "neovim"
        $env.config.show_banner = false

        # Aliases
        alias grep = rg
        alias ncdu = dua
        alias nixos-update = sudo nixos-rebuild switch --flake ${systemFlakePath}
        def gcroots [] {
          sudo nix-store --gc --print-roots | lines | where ($it !~ '^(/nix/var|/run/\w+-system|\{memory|/proc|\{temp:)') | parse "{root} -> {target}" | get root
        }

        # Completer
        let carapace_completer = {|spans|
            ${lib.getExe pkgs.carapace} $spans.0 nushell ...$spans | from json
        }
        $env.config.completions.external = {
          enable: true
          completer: $carapace_completer
        }

        # Direnv, Starship, Zoxide integrations
        $env.DIRENV_CONFIG = "/etc/direnv"
        $env.config.hooks.env_change.PWD = [
          { ||
              if (which direnv | is-empty) {
                  return
              }
              ${lib.getExe pkgs.direnv} export json | from json | default {} | load-env
          }
        ]
        $env.STARSHIP_CONFIG = "${starshipConfig}"
        source ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
        source ($nu.data-dir | path join "vendor/autoload/starship.nu")
      '';
    };
  };
}
