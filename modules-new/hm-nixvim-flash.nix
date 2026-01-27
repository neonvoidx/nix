{ config, ... }:
{
  flake.modules.homeManager.nixvim-flash = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      plugins.flash = {
        enable = true;
        settings = {
          jump = {
            autojump = true;
          };
          modes = {
            search = {
              enabled = false;
            };
          };
        };
      };

      keymaps = [
        {
          mode = [ "n" "x" "o" ];
          key = "s";
          action.__raw = ''
            function()
              require("flash").jump()
            end
          '';
          options.desc = "Flash";
        }
        {
          mode = [ "n" "x" "o" ];
          key = "S";
          action.__raw = ''
            function()
              require("flash").treesitter()
            end
          '';
          options.desc = "Flash Treesitter";
        }
        {
          mode = "o";
          key = "r";
          action.__raw = ''
            function()
              require("flash").remote()
            end
          '';
          options.desc = "Remote Flash";
        }
        {
          mode = [ "o" "x" ];
          key = "R";
          action.__raw = ''
            function()
              require("flash").treesitter_search()
            end
          '';
          options.desc = "Treesitter Search";
        }
        {
          mode = "c";
          key = "<c-s>";
          action.__raw = ''
            function()
              require("flash").toggle()
            end
          '';
          options.desc = "Toggle Flash Search";
        }
      ];
    };
  };
}
