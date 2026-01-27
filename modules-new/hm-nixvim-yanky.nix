{ config, ... }:
{
  flake.modules.homeManager.nixvim-yanky = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      plugins.yanky = {
        enable = true;
        settings = {
          highlight = {
            timer = 200;
          };
        };
      };

      keymaps = [
        {
          mode = [ "n" "x" ];
          key = "y";
          action = "<Plug>(YankyYank)";
        }
        {
          mode = [ "n" "x" ];
          key = "p";
          action = "<Plug>(YankyPutAfter)";
        }
        {
          mode = [ "n" "x" ];
          key = "P";
          action = "<Plug>(YankyPutBefore)";
        }
        {
          mode = "n";
          key = "<c-p>";
          action = "<Plug>(YankyCycleForward)";
        }
        {
          mode = "n";
          key = "<c-n>";
          action = "<Plug>(YankyCycleBackward)";
        }
        {
          mode = "n";
          key = "<leader>pp";
          action = "<cmd>YankyRingHistory<cr>";
          options.desc = "Yank History";
        }
      ];
    };
  };
}
