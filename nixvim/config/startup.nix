# Start menu
{
  plugins.alpha = let
    gaps = 3;
  in {
    enable = true;
    settings.layout = [
      {
        type = "padding";
        val = gaps;
      }
      {
        opts = {
          hl = "Type";
          position = "center";
        };
        type = "text";
        val = [
          " _   _  _____ _____  _   _ ________  ___"
          "| \\ | ||  ___|  _  || | | |_   _|  \\/  |"
          "|  \\| || |__ | | | || | | | | | | .  . |"
          "| . ` ||  __|| | | || | | | | | | |\\/| |"
          "| |\\  || |___\\ \\_/ /\\ \\_/ /_| |_| |  | |"
          "\\_| \\_/\\____/ \\___/  \\___/ \\___/\\_|  |_/"
        ];
      }
      {
        type = "padding";
        val = gaps;
      }
      {
        type = "group";
        val = let
          mkButton = name: command: {
            on_press.__raw = "function() ${command} end";
            type = "button";
            val = name;
            opts.position = "center";
          };
        in [
          (mkButton "File Browser      " "require('telescope.builtin').find_files()")
          (mkButton "New File          " "vim.cmd[[ene]]")
          (mkButton "Vibe Code         󰚩" "vim.cmd[[enew | term gemini]]")
          (mkButton "Recent Files      󰔟" "require('telescope.builtin').oldfiles()")
          (mkButton "Quit Neovim       󰈆" "vim.cmd[[qa]]")
        ];
      }
      {
        type = "padding";
        val = gaps;
      }
      {
        opts = {
          hl = "Keyword";
          position = "center";
        };
        type = "text";
        val = "alex-karev/nixvim";
      }
    ];
  };
}
