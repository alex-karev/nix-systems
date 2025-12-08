{
  pkgs,
  lib,
  ...
}: let
  texlivePackage = pkgs.texliveSmall.withPackages (ps:
    with ps; [
      latexmk
      latexindent
      biblatex
      booktabs
      cleveref
      lipsum
      doi
      units
      microtype
      comment

      # CV
      extsizes
      pdfx
      everyshi
      xmpincl
      fontspec
      paracol
      xecjk
      accsupp
      fontawesome5
      tcolorbox
      tikzfill
      enumitem
      adjustbox
      dashrule
      ifmtarg
      multirow
      changepage

      # Fonts
      newtx
      collection-fontsrecommended
      xkeyval
      xpatch
      xcolor
      xstring
      fontaxes
    ]);
in {
  # Import other modules
  imports = [
    ./config/whichkey.nix
    ./config/telescope.nix
    ./config/keymaps.nix
    ./config/startup.nix
    ./config/ai.nix
  ];

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
  };

  # Clipboard management
  clipboard = {
    providers = {
      wl-copy.enable = true;
    };
    register = "unnamedplus";
  };

  # Extra configs
  extraConfigLua = ''
    -- Disable deprecation warnings
    vim.deprecate = function() end
    -- Make comments brighter and italic
    vim.api.nvim_set_hl(0, 'Comment', { fg = require('mini.base16').config.palette.base04, italic = true })
  '';

  # Plugins
  plugins = {
    lualine.enable = true; # Bottom line
    web-devicons.enable = true; # Icons
    notify.enable = true; # Notifications
    hardtime.enable = true; # Annoying plugin
    lazygit.enable = true; # Git UI
    nvim-autopairs.enable = true; # Autopair brackets
    image.enable = true; # Render images in kitty
    #quarto.enable = true; # Convert markdown to anything
    aerial.enable = true; # Document outlines

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
        clangd.enable = true;
        html.enable = true;
        pyright.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        texlab.enable = true;
        ts_ls.enable = true;
        lua_ls.enable = true;
      };
    };

    # Autoformat
    conform-nvim = {
      enable = true;
      settings = {
        default_format_opts.lsp_format = "fallback";
        formatters = {
          alejandra = {
            command = "${pkgs.alejandra}/bin/alejandra";
          };
          injected = {
            ignore_errors = false;
          };
          black = {
            command = "${pkgs.black}/bin/black";
          };
        };
        formatters_by_ft = {
          "nix" = ["alejandra"];
          "tex" = ["latexindent"];
          "python" = ["black"];
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

    # File browser
    oil = {
      enable = true;
      settings.keymaps = {
        "<C-h>" = "actions.toggle_hidden";
        "<esc>" = "actions.close";
        "<BS>" = "actions.parent";
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
    vimtex = {
      enable = true;
      texlivePackage = texlivePackage;
      settings = {
        view_method = "zathura";
      };
    };
  };
}
