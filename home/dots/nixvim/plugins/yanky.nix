{ ... }:
{
  programs.nixvim = {
    plugins = {
      yanky = {
        enable = true;
        settings = {
          highlight = {
            timer = 200;
          };
        };
      };
    };

    keymaps = [
      {
        key = "y";
        mode = [ "n" "x" ];
        action = "<Plug>(YankyYank)";
      }
      {
        key = "p";
        mode = [ "n" "x" ];
        action = "<Plug>(YankyPutAfter)";
      }
      {
        key = "P";
        mode = [ "n" "x" ];
        action = "<Plug>(YankyPutBefore)";
      }
      {
        key = "<c-p>";
        action = "<Plug>(YankyCycleForward)";
      }
      {
        key = "<c-n>";
        action = "<Plug>(YankyCycleBackward)";
      }
      {
        key = "<leader>pp";
        action = "<cmd>YankyRingHistory<cr>";
      }
    ];
  };
}
