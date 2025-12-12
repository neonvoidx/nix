{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "eldritch";
            component_separators = "";
            section_separators = {
              left = "";
              right = "";
            };
            icons_enabled = true;
            globalstatus = true;
            refresh = {
              statusline = 1000;
              tabline = 1000;
            };
            disabled_filetypes = {
              statusline = [ "dashboard" ];
              tabline = [ "dashboard" ];
            };
          };
          extensions = [ ];
          sections = {
            lualine_a = [{
              __unkeyed-1 = "mode";
              separator = {
                left = "";
                right = "";
              };
            }];
            lualine_b = [ "branch" ];
            lualine_c = [
              {
                __unkeyed-1 = "filename";
                file_status = true;
                newfile_status = true;
                path = 0;
                shorting_target = 40;
              }
              {
                __unkeyed-1 = "diff";
                symbols = {
                  added = " ";
                  modified = "󰣕 ";
                  removed = " ";
                };
              }
              "diagnostics"
            ];
            lualine_x = [
              {
                __unkeyed-1.__raw = "require('noice').api.status.mode.get";
                cond.__raw = "require('noice').api.status.mode.has";
                color = { fg = "#ff9e64"; };
              }
              {
                __unkeyed-1.__raw =
                  "require('gitblame').get_current_blame_text";
                cond.__raw = "require('gitblame').is_blame_text_available";
              }
              { __unkeyed-1 = "overseer"; }
              {
                __unkeyed-1.__raw = #lua
                  ''
                    function()
                      return " "
                    end
                  '';
                color.__raw = #lua
                  ''
                    function()
                      local status = require("sidekick.status").get()
                      if status then
                        return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
                      end
                    end
                  '';
                cond.__raw = #lua
                  ''
                    function()
                      local status = require("sidekick.status")
                      return status.get() ~= nil
                    end
                  '';
              }
              {
                __unkeyed-1.__raw = #lua
                  ''
                    function()
                      local status = require("sidekick.status").cli()
                      return " " .. (#status > 1 and #status or "")
                    end
                  '';
                cond.__raw = #lua
                  ''
                    function()
                      return #require("sidekick.status").cli() > 0
                    end
                  '';
                color.__raw = #lua
                  ''
                    function()
                      return "Special"
                    end
                  '';
              }
            ];
            lualine_y = [ "filetype" { __unkeyed-1 = "location"; } ];
            lualine_z = [ ];
          };
        };
      };
    };

  };
}
