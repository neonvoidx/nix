{ ... }:
{
  plugins.diffview = {
    enable = true;
    enhancedDiffHl = true;
    useIcons = true;
    view = {
      mergeTool = {
        layout = "diff3_horizontal";
        winbarInfo = true;
        disableDiagnostics = true;
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
