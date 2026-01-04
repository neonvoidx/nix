-- Diffview configuration
require("diffview").setup({
  enhanced_diff_hl = true,
})

-- Keymaps
local map = vim.keymap.set
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
map("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "File History" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current File History" })
