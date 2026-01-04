-- Mini.nvim modules configuration

-- Mini.ai - Better text objects
require("mini.ai").setup()

-- Mini.surround - Surround actions
require("mini.surround").setup()

-- Mini.pairs - Auto pairs (disabled in favor of nvim-autopairs)
-- require("mini.pairs").setup()

-- Mini.indentscope - Indent scope visualizer
require("mini.indentscope").setup({
  symbol = "│",
  options = { try_as_border = true },
})
