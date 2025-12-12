{ ... }: {
  programs.nixvim = {
    plugins = {
      todo-comments = {
        enable = true;
        settings = {
          signs = true;
          merge_keywords = false;
          keywords = {
            BUG = {
              icon = "";
              color = "error";
            };
            FIXME = {
              icon = "";
              color = "error";
            };
            fixme = {
              icon = "";
              color = "error";
            };
            HACK = {
              icon = "";
              color = "info";
            };
            NOTE = {
              icon = "❦";
              color = "info";
            };
            note = {
              icon = "❦";
              color = "info";
            };
            TODO = {
              icon = "★";
              color = "actionItem";
            };
            todo = {
              icon = "★";
              color = "actionItem";
            };
            WARN = {
              icon = "󰀦";
              color = "warning";
            };
            warn = {
              icon = "󰀦";
              color = "warning";
            };
            WARNING = {
              icon = "󰀦";
              color = "warning";
            };
          };
          colors = {
            actionItem = [ "ActionItem" "#f1fc79" ];
            default = [ "Identifier" "#37f499" ];
            error = [ "LspDiagnosticsDefaultError" "ErrorMsg" "#f16c75" ];
            info = [ "LspDiagnosticsDefaultInformation" "#ebfafa" ];
            warning = [ "LspDiagnosticsDefaultWarning" "WarningMsg" "#f7c67f" ];
          };
          highlight = {
            keyword = "bg";
            pattern = ".*<(KEYWORDS)\\s*";
          };
          search = {
            command = "rg";
            args = [
              "--color=never"
              "--no-heading"
              "--with-filename"
              "--line-number"
              "--column"
            ];
            pattern = "\\b(KEYWORDS)\\b";
          };
        };
      };
    };

    keymaps = [
      {
        key = "<leader>st";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.todo_comments()
            end
          '';
        options.desc = "Todo";
      }
      {
        key = "<leader>sT";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
            end
          '';
        options.desc = "Todo/Fix/Fixme";
      }
    ];
  };
}
