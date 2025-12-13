return {
  "folke/todo-comments.nvim",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = true, -- show icons in the signs column
    merge_keywords = false, -- use only these
    keywords = {
      BUG = { icon = "", color = "error" },
      FIXME = { icon = "", color = "error" },
      fixme = { icon = "", color = "error" },
      HACK = { icon = "", color = "info" },
      NOTE = { icon = "❦", color = "info" },
      note = { icon = "❦", color = "info" },
      TODO = { icon = "★", color = "actionItem" },
      todo = { icon = "★", color = "actionItem" },
      WARN = { icon = "󰀦", color = "warning" },
      warn = { icon = "󰀦", color = "warning" },
      WARNING = { icon = "󰀦", color = "warning" },
    },
    colors = {
      actionItem = { "ActionItem", "#f1fc79" },
      default = { "Identifier", "#37f499" },
      error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#f16c75" },
      info = { "LspDiagnosticsDefaultInformation", "#ebfafa" },
      warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#f7c67f" },
    },
    highlight = {
      keyword = "bg",
      pattern = [[.*<(KEYWORDS)\s*]],
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      pattern = [[\b(KEYWORDS)\b]],
    },
  },
  keys = {
    {
      "<leader>st",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo",
    },
    {
      "<leader>sT",
      function()
        Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
      end,
      desc = "Todo/Fix/Fixme",
    },
  },
}
