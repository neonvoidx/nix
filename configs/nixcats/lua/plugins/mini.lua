-- Mini.nvim modules configuration

-- Mini.ai - Better text objects
require("mini.ai").setup()

-- Mini.surround - Surround actions
require("mini.surround").setup()

-- Mini.indentscope - Indent scope visualizer
require("mini.indentscope").setup({
  symbol = "│",
  options = { try_as_border = true },
})
