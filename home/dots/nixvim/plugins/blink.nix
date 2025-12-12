{ ... }: {
  programs.nixvim = {
    plugins = {
      blink-cmp = {
        enable = true;
        settings = {
          enabled.__raw = #lua
            ''
              function()
                return not vim.tbl_contains({ "oil" }, vim.bo.filetype) and vim.bo.buftype ~= "prompt"
              end
            '';

          fuzzy = { sorts = [ "exact" "score" "sort_text" ]; };

          sources = {
            default = [ "copilot" "lsp" "path" "lazydev" "snippets" "buffer" ];
            providers = {
              path = {
                name = "path";
                opts = {
                  get_cwd.__raw = #lua
                    ''
                      function(_)
                        return vim.fn.getcwd()
                      end
                    '';
                };
                score_offset = 5;
              };
              copilot = {
                name = "copilot";
                module = "blink-copilot";
                score_offset = 4;
                async = true;
              };
              lazydev = {
                name = "LazyDev";
                module = "lazydev.integrations.blink";
                score_offset = 6;
              };
              lsp = {
                name = "LSP";
                module = "blink.cmp.sources.lsp";
                score_offset = 7;
              };
              snippets = {
                name = "snippets";
                opts = {
                  search_paths =
                    [ (builtins.toString ~/.config/nvim/snippets) ];
                };
                score_offset = 3;
              };
            };
            per_filetype = { codecompanion = [ "codecompanion" ]; };
          };

          completion = {
            menu = {
              min_width = 60;
              border = "rounded";
              draw = {
                padding = [ 0 1 ];
                columns = [
                  [ "kind_icon" { gap = 1; } ]
                  [ "label" "label_description" ]
                  [ "source_name" ]
                ];
              };
            };
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 500;
              window = { border = "rounded"; };
            };
            trigger = { prefetch_on_insert = false; };
            list = {
              selection = {
                preselect = true;
                auto_insert = true;
              };
            };
          };

          keymap = {
            preset = "none";
            "<C-k>" = [ "select_prev" "fallback" ];
            "<C-j>" = [ "select_next" "fallback" ];
            "<Tab>" = [ "accept" "fallback" ];
            "<C-l>" = [ "scroll_documentation_up" "fallback" ];
            "<C-h>" = [ "scroll_documentation_down" "fallback" ];
            "<Up>" = [ "select_prev" "fallback" ];
            "<Down>" = [ "select_next" "fallback" ];
            "<S-Tab>" = [ "snippet_forward" "fallback" ];
            "<C-Tab>" = [ "snippet_backward" "fallback" ];
            "<C-e>" = [ "hide" "fallback" ];
            "<C-space>" = [ "show" "show_documentation" "hide_documentation" ];
          };
        };
      };
      blink-copilot.enable = true;
    };
  };
}
