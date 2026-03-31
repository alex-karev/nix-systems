# Ai companion
let
  provider = "custom";
  baseUrl = "vim.env.OPENAI_BASE_URL or \"http://localhost:3042/openai\"";
  apiKey = "vim.env.OPENAI_API_KEY or \"nokey\"";
  model = "vim.env.OPENAI_MODEL or \"tensorzero::function_name::codecompanion\"";
  inline_model = "vim.env.OPENAI_MODEL or \"tensorzero::function_name::codecompanion-inline\"";
  cmp_model = "vim.env.OPENAI_MODEL or \"tensorzero::function_name::cmp\"";
  intro = "Hi, what's up? ✌️ Press ? to see options";
in {
  plugins = {
    codecompanion = {
      enable = true;
      settings = {
        adapters.show_defaults = false;
        adapters.http.gemini.__raw = ''
          function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = vim.env.GEMINI_API_KEY,
              },
            })
          end
        '';
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
        adapters.http.custom_inline.__raw = ''
          function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = ${baseUrl},
                api_key = ${apiKey},
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = {
                  default = ${inline_model},
                },
              },
            })
          end
        '';

        display.chat.intro_message = intro;
        strategies = {
          # chat.opts.system_prompt.__raw = ''
          #   function(ctx)
          #     return string.format([[${systemPrompt}]],
          #     ctx.language,
          #     ctx.date,
          #     ctx.nvim_version,
          #     ctx.os
          #     )
          #   end
          # '';
          chat.roles.llm.__raw = ''
            function (adapter)
              local model = adapter.schema.model.default
              if type(model) == "function" then
                model = model()
              end
              return "AI (" .. model .. ")"
            end
          '';
          chat.adapter = "custom";
          inline.adapter = "custom_inline";
          cmd.adapter = "custom_inline";
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
          end_point.__raw = "(${baseUrl}) .. \"/v1/chat/completions\"";
          model.__raw = cmp_model;
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
