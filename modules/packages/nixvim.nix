# Nixvim configuration
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
    packages.nixvim = inputs.nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvim {
      # Pass colorScheme to all modules

      # Import other modules
      imports = [
        ./nixvim/keymaps.nix
        ./nixvim/whichkey.nix
        ./nixvim/telescope.nix
        ./nixvim/startup.nix
        ./nixvim/ai.nix
      ];

      colorschemes.base16 = {
        enable = true;
        colorscheme = theme.colors.base16;
      };

      # Globals
      globals = {
        mapleader = " ";
        maplocalleader = " ";
        have_nerd_font = true;
        markdown_fenced_languages = ["html" "python" "lua" "typescript" "javascript" "rust" "c" "cpp"];
      };

      # Options
      opts = {
        number = true;
        relativenumber = true;
        mouse = "a";
        breakindent = true;
        undofile = true;
        showmode = false;
        ignorecase = true;
        smartcase = true;
        wrap = true;
        signcolumn = "yes";
        updatetime = 250;
        timeoutlen = 300;
        splitright = true;
        splitbelow = true;
        list = true;
        listchars = {
          tab = "» ";
          trail = "·";
          nbsp = "␣";
        };
        inccommand = "split";
        cursorline = true;
        scrolloff = 10;
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
        autoindent = true;
        smartindent = true;
        expandtab = true;
        spelllang = "en";
        foldlevelstart = 99;
        foldlevel = 99;
        foldenable = true;
      };

      # Clipboard management
      clipboard = {
        providers.wl-copy.enable = true;
        register = "unnamedplus";
      };

      # Extra configs
      extraConfigLua = let
        commentColor = theme.colors.base16.base04;
      in ''
        -- Disable deprecation warnings
        vim.deprecate = function() end
        -- Make comments brighter and italic
        vim.api.nvim_set_hl(0, 'Comment', { fg = '${commentColor}', italic = true})
        vim.api.nvim_set_hl(0, '@comment', { fg = '${commentColor}', italic = true})
        vim.api.nvim_set_hl(0, 'TSComment', { fg = '${commentColor}', italic = true})
      '';

      # Fix telescope
      extraPlugins = with pkgs.vimPlugins; [
        plenary-nvim
      ];

      # Plugins
      plugins = {
        lualine.enable = true; # Bottom line
        web-devicons.enable = true; # Icons
        notify.enable = true; # Notifications
        hardtime.enable = true; # Annoying plugin
        lazygit.enable = true; # Git UI
        nvim-autopairs.enable = true; # Autopair brackets
        aerial.enable = true; # Document outlines
        gitsigns.enable = true; # Enable git diff signs
        nvim-ufo.enable = true; # Improved code folding
        mini-files.enable = true; # File browser

        # Parsing
        treesitter = {
          enable = true;
          settings.highlight.enable = true;
        };

        # Language server
        lsp = {
          enable = true;
          servers = {
            nixd.enable = true;
            jsonls.enable = true;
            cssls.enable = true;
            cmake.enable = true;
            svelte.enable = true;
            clangd.enable = true;
            html.enable = true;
            pyright.enable = true;
            rust_analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
            };
            texlab.enable = true;
            vtsls.enable = true;
            lua_ls.enable = true;
          };
        };

        # Autoformat
        conform-nvim = {
          enable = true;
          settings = {
            default_format_opts.lsp_format = "fallback";
            formatters = {
              injected = {
                ignore_errors = false;
              };
              alejandra.command = lib.getExe pkgs.alejandra;
              black.command = lib.getExe pkgs.black;
              prettierd.command = lib.getExe pkgs.prettierd;
            };
            formatters_by_ft = {
              nix = ["alejandra"];
              tex = ["latexindent"];
              python = ["black"];
              javascript = ["prettierd"];
              typescript = ["prettierd"];
              svelte = ["prettierd"];
            };
          };
        };

        # Autocomplete
        cmp = {
          enable = true;
          settings = {
            sources = [
              {name = "nvim_lsp";}
              {name = "luasnip";}
              {name = "path";}
              {name = "buffer";}
              {name = "nvim_lsp_signature_help";}
            ];
            mapping = {
              "<Tab>" = "cmp.mapping.select_next_item()";
              "<S-Tab>" = "cmp.mapping.select_prev_item()";
              "<CR>" = "cmp.mapping.confirm { select = true }";
              "<S-j>" = "cmp.mapping.scroll_docs(-4)";
              "<S-k>" = "cmp.mapping.scroll_docs(4)";
            };
          };
        };

        # Stylized command paletter and search
        noice = {
          enable = true;
          settings.presets = {
            bottom_search = true;
            command_palette = false;
            long_message_to_split = true;
            inc_name = false;
            lsp_doc_border = true;
          };
        };

        # Tabs
        barbar = {
          enable = true;
          settings = {
            animation = false;
            exclude_ft = ["lspinfo" "qf" "help"];
            icons.separator_at_end = false;
          };
        };

        # Comment lines and chunks of code
        mini = {
          enable = true;
          modules.comment.mappings = {
            comment = "<leader>/";
            comment_line = "<leader>/";
            comment_visual = "<leader>/";
            textobject = "<leader>/";
          };
        };

        # LaTeX support
        # TODO: I did not like it anyway, so I can consider using a different build system
        # vimtex = {
        #   enable = true;
        #   settings = {
        #     view_method = "zathura";
        #   };
        # };
      };
    };
  };
}
