{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "quicker";
          src = pkgs.fetchFromGitHub {
            owner = "stevearc";
            repo = "quicker.nvim";
            rev = "a60417428e98bdce89e839831e08aeaed1e10f1f";
            hash = "sha256-a+u1CMYn/FGvPsbtTSdgGPSnP4gXJGGa9r8u5mFQKjg=";
          };
        };
        config = ''
          lua << EOF
          require("quicker").setup({
            keys = {
              {
                ">",
                function()
                  require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                end,
                desc = "Expand quickfix context",
              },
              {
                "<",
                function()
                  require("quicker").collapse()
                end,
                desc = "Collapse quickfix context",
              },
            },
          })
          EOF
        '';
      }
    ];

    keymaps = [
      {
        key = "<leader>q";
        action.__raw = ''
          function()
            require("quicker").toggle()
          end
        '';
        options.desc = "Toggle quickfix";
      }
    ];
  };
}
