{
  keymaps = let
    noClip = key: {
      mode = "n";
      inherit key;
      action = "\"_${key}";
    };
  in [
    # Do not copy on delete single characters and rewrite
    (noClip "x")
    (noClip "c")
    (noClip "C")

    # Exit terminal mode
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
    }

    # Autoformat
    {
      mode = "n";
      key = "<leader>fm";
      action.__raw = ''
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end
      '';
      options.desc = "[F]or[M]at buffer";
    }

    # Telescope
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<cr>";
      options.desc = "[F]ind [F]iles";
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<cr>";
      options.desc = "[F]ind [H]elp";
    }
    {
      mode = "n";
      key = "<leader>fk";
      action = "<cmd>Telescope keymaps<cr>";
      options.desc = "[F]ind [K]eymaps";
    }
    {
      mode = "n";
      key = "<leader>fs";
      action = "<cmd>Telescope builtin<cr>";
      options.desc = "[F]ind [S]ettings";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<cr>";
      options.desc = "[F]ind by [G]rep";
    }
    {
      mode = "n";
      key = "<leader>fd";
      action = "<cmd>Telescope diagnostics<cr>";
      options.desc = "[F]ind [D]iagnostics";
    }
    {
      mode = "n";
      key = "<leader>ft";
      action = "<cmd>Telescope buffers<cr>";
      options.desc = "[F]ind [T]abs";
    }
    {
      mode = "n";
      key = "<leader>fo";
      action = "<cmd>Telescope aerial<cr>";
      options.desc = "[F]ind [O]utline";
    }
    {
      mode = "n";
      key = "<leader><leader>";
      action = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
      options.desc = "Fuzzy find in current buffer";
    }

    # Buffer navigation
    {
      mode = "n";
      key = "<Tab>";
      action = "<cmd>BufferNext<CR>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<S-Tab>";
      action = "<cmd>BufferPrev<CR>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Oil --float .<CR>";
      options.desc = "[F]ile [B]rowser";
    }

    # Diagnostics
    # {
    #   mode = "n";
    #   key = "<leader>e";
    #   action.__raw = ''
    #     function()
    #       vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
    #     end
    #   '';
    #   options.desc = "Show line diagnostics";
    # }

    # Arrow key reminders
    {
      mode = ["i" "n"];
      key = "<left>";
      action = "<cmd>echo \"Use h to move!! (<C-h> in insert mode)\"<CR>";
    }
    {
      mode = ["i" "n"];
      key = "<right>";
      action = "<cmd>echo \"Use l to move!! (<C-l> in insert mode)\"<CR>";
    }
    {
      mode = ["i" "n"];
      key = "<up>";
      action = "<cmd>echo \"Use k to move!! (<C-k> in insert mode)\"<CR>";
    }
    {
      mode = ["i" "n"];
      key = "<down>";
      action = "<cmd>echo \"Use j to move!! (<C-j> in insert mode)\"<CR>";
    }

    # Insert mode movement
    {
      mode = "i";
      key = "<C-h>";
      action = "<left>";
      options.desc = "Move left in insert mode";
    }
    {
      mode = "i";
      key = "<C-l>";
      action = "<right>";
      options.desc = "Move right in insert mode";
    }
    {
      mode = "i";
      key = "<C-k>";
      action = "<up>";
      options.desc = "Move up in insert mode";
    }
    {
      mode = "i";
      key = "<C-j>";
      action = "<down>";
      options.desc = "Move down in insert mode";
    }

    # Window navigation
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w><C-h>";
      options.desc = "Move focus to the left window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w><C-l>";
      options.desc = "Move focus to the right window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w><C-j>";
      options.desc = "Move focus to the lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w><C-k>";
      options.desc = "Move focus to the upper window";
    }

    # Buffer management
    {
      mode = "n";
      key = "<leader>b";
      action = "<cmd>enew<CR>";
      options.desc = "Open new buffer";
    }
    {
      mode = "n";
      key = "<leader>x";
      action = "<cmd>BufferClose<CR>";
      options.desc = "Close buffer";
    }

    # LazyGit
    {
      mode = "n";
      key = "<leader>gl";
      action = "<cmd>LazyGit<CR>";
      options.desc = "[L]azy[G]it";
    }

    # Select again after indent
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options.desc = "Indent right and reselect";
    }
    {
      mode = "v";
      key = "<";
      action = "<gv";
      options.desc = "Indent left and reselect";
    }

    # Clear search
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlight in normal mode";
    }

    # LSP actions
    {
      mode = "n";
      key = "<leader>ld";
      action = "<cmd>Telescope lsp_definitions<cr>";
      options.desc = "[D]efinition";
    }
    {
      mode = "n";
      key = "<leader>lr";
      action = "<cmd>Telescope lsp_references<cr>";
      options.desc = "[R]eferences";
    }
    {
      mode = "n";
      key = "<leader>li";
      action = "<cmd>Telescope lsp_implementations<cr>";
      options.desc = "[I]mplementation";
    }
    {
      mode = "n";
      key = "<leader>lt";
      action = "<cmd>Telescope lsp_type_definitions<cr>";
      options.desc = "[T]ype Definition";
    }
    {
      mode = "n";
      key = "<leader>ls";
      action = "<cmd>Telescope lsp_document_symbols<cr>";
      options.desc = "[S]ymbols";
    }
    {
      mode = "n";
      key = "<leader>lw";
      action = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>";
      options.desc = "[W]orkspace Symbols";
    }
    {
      mode = "n";
      key = "<leader>ln";
      action = "<cmd>lua vim.lsp.buf.rename()<cr>";
      options.desc = "Re[N]ame";
    }
    {
      mode = ["n" "x"];
      key = "<leader>la";
      action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
      options.desc = "Code [A]ction";
    }
    {
      mode = "n";
      key = "<leader>lD";
      action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
      options.desc = "[D]eclaration";
    }

    # AI
    {
      mode = "n";
      key = "<leader>aa";
      action = "<cmd>CodeCompanionChat<cr>";
      options.desc = "[A]sk [A]I";
    }
    {
      mode = "n";
      key = "<leader>ap";
      action = "<cmd>CodeCompanion<cr>";
      options.desc = "[A]I [P]rompt";
    }
    {
      mode = "n";
      key = "<leader>av";
      action = "<cmd>term gemini<cr>";
      options.desc = "[A]I [V]ibecode";
    }
 
    {
      mode = "v";
      key = "<leader>ae";
      action = "<cmd>CodeCompanion<cr>";
      options.desc = "[A]I [E]dit";
    }

    # Code actions
    {
      mode = "n";
      key = "<leader>cs";
      action = "<cmd>lua vim.o.spell = not vim.o.spell<cr>";
      options.desc = "[C]heck [S]pelling";
    }
  ];
}
