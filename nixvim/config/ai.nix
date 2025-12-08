# Ai companion
let
  #provider = "gemini";
  provider = "custom";
  baseUrl = "vim.env.OPENAI_BASE_URL";
  apiKey = "vim.env.OPENAI_API_KEY";
  model = "vim.env.OPENAI_MODEL";
in {
  plugins = {
    codecompanion = {
      enable = true;
      settings = {
        adapters.http.custom.__raw = ''
          function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = ${baseUrl},
                api_key = ${apiKey},
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = {
                  default = ${model},
                },
              },
            })
          end
        '';
        strategies = {
          chat.adapter = provider;
          inline.adapter = provider;
          cmd.adapter = provider;
        };
      };
    };
    minuet = {
      enable = true;
      settings = {
        provider =
          if (provider == "custom")
          then "openai_compatible"
          else provider;
        cmp.enable_auto_complete = false;
        blink.enable_auto_complete = false;
        virtualtext.keymap = {
          next = "<A-c>";
          accept = "<A-a>";
          dismiss = "<A-e>";
        };
        provider_options.openai_compatible = {
          api_key.__raw = "function () return ${apiKey} end";
          end_point.__raw = "${baseUrl} .. \"/v1/chat/completions\"";
          model.__raw = model;
          name = "custom";
          stream = true;
        };
      };
    };
    # cmp.settings = {
    #   mapping."<A-c>" = "require('minuet').make_cmp_map()";
    #   sources = [{name = "minuet";}];
    # };
  };
}
