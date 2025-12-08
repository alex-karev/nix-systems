{
  plugins.telescope = {
    enable = true;
    settings = {
      defaults.mappings.i.__raw = ''
        {
          ['<Tab>'] = 'move_selection_next',
          ['<S-Tab>'] = 'move_selection_previous',
          ['<esc>'] = 'close',
        }
      '';

      pickers.find_files = {
        layout_config.prompt_position = "top";
        sorting_strategy = "ascending";
        mappings.i.__raw = ''
          {
            ['<C-h>'] = {
              function(prompt_bufnr)
                local actions = require 'telescope.actions'
                local action_state = require 'telescope.actions.state'
                local current_line = action_state.get_current_line()
                actions.close(prompt_bufnr)
                vim.schedule(function()
                  require('telescope.builtin').find_files {
                    default_text = current_line,
                    find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*', '--glob', '**/.*' },
                  }
                end)
              end,
            },
          }
        '';
      };
    };
    extensions = {
      zoxide.enable = true;
    };
  };
}
