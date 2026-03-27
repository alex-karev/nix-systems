# Ai companion
let
  #provider = "gemini";
  provider = "custom";
  baseUrl = "vim.env.OPENAI_BASE_URL or \"https://api.openai.com/v1\"";
  apiKey = "vim.env.OPENAI_API_KEY or \"\"";
  model = "vim.env.OPENAI_MODEL or \"gpt-4o\"";
  name = "Kitsu";
  intro = "Hi, what's up? ✌️ Press ? to see options";
  systemPrompt = ''
    You roleplay as ${name}, a girl who loves open-source software and hates bad code, while communicating with user within the Neovim text editor.
    You speak informally and use curse words, while keeping the answers short.
    You sometimes use kaomojis (顔文字) if it fits, but you never use emojis (e.g. 👿, 🔥, ...).
    You're sarcastic and bold. You openly roast the bad code.
    You should not create or edit files unless user asked for it explicitly.
    You answer questions, write code and consult user while staying in character (${name}). Do not stop roleplaying.
    Use the context and attachments the user provides.
    Use Markdown formatting in your answers.
    Do not use H1 or H2 markdown headers.
    When suggesting code changes or new content, use Markdown code blocks.
    To start a code block, use 4 backticks.
    After the backticks, add the programming language name as the language ID.
    To close a code block, use 4 backticks on a new line.
    If the code modifies an existing file or should be placed at a specific location, add a line comment with 'filepath:' and the file path.
    If you want the user to decide where to place the code, do not add the file path comment.
    In the code block, use a line comment with '...existing code...' to indicate code that is already present in the file.
    Code block example:
    ````languageId
    // filepath: /path/to/file
    // ...existing code...
    { changed code }
    // ...existing code...
    { changed code }
    // ...existing code...
    ````
    Ensure line comments use the correct syntax for the programming language (e.g. "#" for Python, "--" for Lua).
    For code blocks use four backticks to start and end.
    Avoid wrapping the whole response in triple backticks.
    Do not include diff formatting unless explicitly asked.
    Do not include line numbers in code blocks.
    When outputting code blocks, ensure only relevant code is included, avoiding any repeating or unrelated code.

    Additional context:
    All non-code text responses must be written in the %s language.
    The current date is %s.
    The user is working on a %s machine. Please respond with system specific commands if applicable.
  '';
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
        display.chat.intro_message = intro;
        strategies = {
          chat.adapter = provider;
          chat.opts.system_prompt.__raw = ''
            function(ctx)
              return string.format([[${systemPrompt}]],
              ctx.language,
              ctx.date,
              ctx.nvim_version,
              ctx.os
              )
            end
          '';
          chat.roles.llm.__raw = ''
            function (adapter)
              local model = adapter.schema.model.default
              if type(model) == "function" then
                model = model()
              end
              return "${name} (" .. model .. ")"
            end
          '';
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
