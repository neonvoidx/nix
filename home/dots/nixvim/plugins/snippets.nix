{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-scissors";
          src = pkgs.fetchFromGitHub {
            owner = "chrisgrieser";
            repo = "nvim-scissors";
            rev = "bb4c8e19d20dc8ecd1e6f2b7da879bb7d64e5cd9";
            hash = "sha256-HsF0Lx9aNwQ5jq7fOkSi+G+Tq5+oFgv2eKOgYRm2FBs=";
          };
        };
        config = ''
          lua << EOF
          require("scissors").setup({
            snippetDir = vim.fn.stdpath("config") .. "/snippets",
          })
          EOF
        '';
      }
      friendly-snippets
    ];

    keymaps = [
      {
        key = "<leader>Sa";
        mode = "v";
        action.__raw = ''
          function()
            require("scissors").addNewSnippet()
          end
        '';
        options.desc = "✀  Add Snippet";
      }
      {
        key = "<leader>Se";
        action.__raw = ''
          function()
            require("scissors").editSnippet()
          end
        '';
        options.desc = "✀  Edit Snippet";
      }
    ];
  };
}
