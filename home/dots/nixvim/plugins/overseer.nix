{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "overseer";
          src = pkgs.fetchFromGitHub {
            owner = "stevearc";
            repo = "overseer.nvim";
            rev = "7b60ceacf2ea0a85b7c5aea3f34f3c8f36f0afce";
            hash = "sha256-eo2qc0WmDPa4wnmgU+77CjyEfzEyOYDMbVvdqeIZ5Ro=";
          };
        };
        config = ''
          lua << EOF
          require("overseer").setup({
            templates = {
              "builtin",
            },
          })
          EOF
        '';
      }
    ];

    keymaps = [
      {
        key = "<leader>or";
        action = "<cmd>OverseerRun<cr>";
        options.desc = "Run Task";
      }
      {
        key = "<leader>ol";
        action = "<cmd>OverseerToggle<cr>";
        options.desc = "Toggle Task List";
      }
    ];
  };
}
