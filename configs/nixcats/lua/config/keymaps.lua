-- Keymaps
local map = vim.keymap.set

-- Better j/k navigation with wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
map("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / clear hlsearch / diff update" })

-- Saner behavior of n and N
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w!<cr><esc>", { desc = "Save file" })

-- Save all buffers and close
map({ "i", "n" }, "<C-q>", "<cmd>silent! xa<cr>", { desc = "Save all and quit" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Windows
map("n", "<leader>wd", "<cmd>q<cr>", { desc = "Delete window", remap = true })
map("n", "<leader>w|", "<cmd>vsplit<cr>", { desc = "Split window right", remap = true })
map("n", "<leader>w-", "<cmd>split<cr>", { desc = "Split window below", remap = true })

-- Rebind jj and kk to escape
map("i", "jj", "<Esc>")
map("i", "kk", "<Esc>")

-- Remap Insert to Esc
map({ "i", "n", "v", "x", "o", "t", "s", "c", "l" }, "<Insert>", "<Esc>")

-- Unbind F1 help
map({ "i", "n", "v", "x", "o", "t", "s", "c", "l" }, "<F1>", "<Nop>")

-- Unbind ctrl left click
map({ "i", "n", "v", "x", "o", "t", "s", "c", "l" }, "<C-LeftMouse>", "<Nop>")

-- Unbind tags
map("n", "<C-t>", "<Nop>")

-- Remap D to blackhole delete
map({ "n", "v" }, "D", '"_d')

-- Remap C to blackhole change
map({ "n", "v" }, "C", '"_c')

-- Backspace in normal mode to go to start of line
map("n", "<Backspace>", "^", { desc = "Move to first non blank character" })

-- Toggle word wrap
map("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify("Wrap " .. (vim.wo.wrap and "enabled" or "disabled"))
end, { desc = "Toggle Wrap" })
