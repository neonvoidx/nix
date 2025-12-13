return {
  "sindrets/diffview.nvim",
  vscode = false,
  setup = function()
    require("diffview").setup({
      enhanced_diff_hl = true,
      use_icons = true,
      view = { merge_tool = { layout = "diff3_horizontal", winbar_info = true, disable_diagnostics = true } },
    })
  end,
  keys = {
    {
      "<leader>gd",
      function()
        local lib = require("diffview.lib")
        local view = lib.get_current_view()
        if view then
          vim.cmd.DiffviewClose()
        else
          vim.cmd.DiffviewOpen()
        end
      end,
      desc = "Diffview",
    },
  },
}
