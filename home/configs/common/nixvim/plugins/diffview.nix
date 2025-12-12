{ ... }:
{
  plugins.diffview = {
    enable = true;
    settings = {
      enhanced_diff_hl = true;
      use_icons = true;
      view = {
        merge_tool = {
          layout = "diff3_horizontal";
          winbar_info = true;
          disable_diagnostics = true;
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
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
}
