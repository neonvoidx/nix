{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "diffview";
          src = pkgs.fetchFromGitHub {
            owner = "sindrets";
            repo = "diffview.nvim";
            rev = "4516612fe8b0281d2dc0e79c799a00107cb40d52";
            hash = "sha256-YcphPMq+8w4E5rWvD20kTBQe70fLbzz62sQpAE+qZ0E=";
          };
        };
        config = ''
          lua << EOF
          require("diffview").setup({
            enhanced_diff_hl = true,
            use_icons = true,
            view = {
              merge_tool = {
                layout = "diff3_horizontal",
                winbar_info = true,
                disable_diagnostics = true,
              },
            },
          })
          EOF
        '';
      }
    ];

    keymaps = [
      {
        key = "<leader>gd";
        action.__raw = ''
          function()
            local lib = require("diffview.lib")
            local view = lib.get_current_view()
            if view then
              vim.cmd.DiffviewClose()
            else
              vim.cmd.DiffviewOpen()
            end
          end
        '';
        options.desc = "Diffview";
      }
    ];
  };
}
