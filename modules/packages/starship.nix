# Starship configuration
{
  self,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.starshipConfig = let
      tomlFormat = pkgs.formats.toml {};
    in
      tomlFormat.generate "starship.toml" {
        add_newline = false;
        format = "$username$hostname$nix_shell$directory$python$character";
        right_format = "$git_branch$git_state$git_status$cmd_duration ";

        directory.style = "bright-black";

        nix_shell = {
          style = "cyan";
          format = ''[\($name\)]($style) '';
        };

        username = {
          format = "[$user]($style) ";
          style_user = "red";
          show_always = true;
        };

        character = {
          success_symbol = "[>](red)";
          error_symbol = "[x](purple) [>](red)";
          vimcmd_symbol = "[<](orange)";
        };

        git_branch = {
          format = "[$branch]($style)";
          style = "purple";
        };

        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "​";
          untracked = "​";
          modified = "​";
          staged = "​";
          renamed = "​";
          deleted = "​";
          stashed = "≡";
        };

        git_state = {
          format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
          style = "bright-black";
        };

        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };

        python = {
          format = "[$virtualenv]($style) ";
          style = "bright-black";
          detect_extensions = [];
          detect_files = [];
        };
      };
  };
}
