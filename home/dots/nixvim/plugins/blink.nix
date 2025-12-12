{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      blink-cmp = {
        enable = true;
        settings = {
          enabled.__raw = ''
            function()
              return not vim.tbl_contains({ "oil" }, vim.bo.filetype) and vim.bo.buftype ~= "prompt"
            end
          '';

          fuzzy = {
            sorts = [ "exact" "score" "sort_text" ];
          };

          sources = {
            default = [ "copilot" "lsp" "path" "lazydev" "snippets" "buffer" ];
            providers = {
              path = {
                name = "path";
                opts = {
                  get_cwd.__raw = ''
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
                  search_paths = [ (builtins.toString ~/.config/nvim/snippets) ];
                };
                score_offset = 3;
              };
            };
            per_filetype = {
              codecompanion = [ "codecompanion" ];
            };
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
                components = {
                  kind_icon = {
                    text.__raw = ''
                      function(ctx)
                        local icon = ctx.kind_icon
                        if vim.tbl_contains({ "path" }, ctx.source_name) then
                          local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                          if dev_icon then
                            icon = dev_icon
                          end
                        else
                          icon = require("lspkind").symbolic(ctx.kind, {
                            mode = "symbol",
                          })
                        end

                        local override_icons = {
                          copilot = "",
                          ripgrep = "",
                          snippets = "",
                        }

                        if override_icons[ctx.source_name] then
                          return override_icons[ctx.source_name] .. ctx.icon_gap
                        end

                        return icon .. ctx.icon_gap
                      end
                    '';
                    highlight.__raw = ''
                      function(ctx)
                        local hl = ctx.kind_hl
                        if vim.tbl_contains({ "Path" }, ctx.source_name) then
                          local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                          if dev_icon then
                            hl = dev_hl
                          end
                        end
                        return hl
                      end
                    '';
                  };
                  source_name = {
                    highlight.__raw = ''
                      function()
                        local highlight = "BlinkCmpLabel"
                        return highlight
                      end
                    '';
                  };
                  label_description = {
                    width = {
                      fill = true;
                    };
                  };
                };
              };
            };
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 500;
              window = {
                border = "rounded";
              };
            };
            trigger = {
              prefetch_on_insert = false;
            };
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
    };

    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "blink-copilot";
          src = pkgs.fetchFromGitHub {
            owner = "fang2hou";
            repo = "blink-copilot";
            rev = "c0d0e89d42dc4c22d7e09e20d4de1c96d1e3fe76";
            hash = "sha256-0kfU9tA7qpIxK7kl2O2/EWb0oe2KVK+FnK5W0vNjQVw=";
          };
        };
      }
      nvim-web-devicons
    ];
  };
}
