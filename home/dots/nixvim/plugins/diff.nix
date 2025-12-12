{ pkgs, ... }: {
  programs.nixvim = {
    plugins.diffview.enable = true;
    # TODO
    # config = ''
    #   lua << EOF
    #   require("diffview").setup({
    #     enhanced_diff_hl = true,
    #     use_icons = true,
    #     view = {
    #       merge_tool = {
    #         layout = "diff3_horizontal",
    #         winbar_info = true,
    #         disable_diagnostics = true,
    #       },
    #     },
    #   })
    #   EOF
    # '';

    keymaps = [{
      key = "<leader>gd";
      action.__raw = # lua
        ''
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
    }];
  };
}
