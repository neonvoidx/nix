-- Yanky yank history configuration
require("yanky").setup({
  ring = {
    history_length = 100,
    storage = "shada",
  },
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 200,
  },
})

-- Keymaps
local map = vim.keymap.set
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
map("n", "<c-p>", "<Plug>(YankyCycleForward)")
map("n", "<c-n>", "<Plug>(YankyCycleBackward)")
