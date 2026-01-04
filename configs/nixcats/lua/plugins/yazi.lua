-- Yazi file manager integration
require("yazi").setup({
  open_for_directories = false,
})

-- Keymaps
local map = vim.keymap.set
map("n", "<leader>e", function() require("yazi").yazi() end, { desc = "Open yazi" })
