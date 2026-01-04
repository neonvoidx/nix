-- Which-key configuration
require("which-key").setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
  },
})

-- Register leader key groups
local wk = require("which-key")
wk.add({
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code" },
  { "<leader>f", group = "file/find" },
  { "<leader>g", group = "git" },
  { "<leader>s", group = "search" },
  { "<leader>u", group = "ui" },
  { "<leader>w", group = "windows" },
  { "<leader>x", group = "diagnostics/quickfix" },
})
