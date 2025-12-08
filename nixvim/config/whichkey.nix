{
  plugins.which-key = {
    enable = true;
    settings = {
      delay = 100;
      spec = [
        {
          __unkeyed-1 = "<leader>f";
          group = "[F]ind/[F]ormat";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "[C]ode";
          mode = ["n" "x"];
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "[D]ocument";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "[L]SP";
        }
        {
          __unkeyed-1 = "<leader>n";
          group = "[N]ew";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "[G]it";
        }
        {
          __unkeyed-1 = "<leader>p";
          group = "[P]roject";
        }
        {
          __unkeyed-1 = "<leader>a";
          group = "[A]I";
        }
        {
          __unkeyed-1 = "<leader>h";
          group = "Git [H]unk";
          mode = ["n" "v"];
        }
      ];
    };
  };
}
