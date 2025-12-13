local map = vim.keymap.set

-- better up/down
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
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
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

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w!<cr><esc>", { desc = "Save file" })
-- Save all buffers and close
map({ "i", "n" }, "<C-q>", "<cmd>silent! xa<cr>", { desc = "Save all and quit" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- windows
map("n", "<leader>wd", "<cmd>q<cr>", { desc = "Delete window", remap = true })
map("n", "<leader>w|", "<cmd>vsplit<cr>", { desc = "Split window right", remap = true })
map("n", "<leader>w-", "<cmd>split<cr>", { desc = "Split window below", remap = true })

-- -- Rebind jj  and kk to escape
-- Superceded by betterescape
map({ "i" }, "jj", "<Esc>")
map({ "i" }, "kk", "<Esc>")

-- remap Insert to Esc, aka my CAPS lock key which is always bound to Insert on my desktop
map({ "i", "n", "v", "x", "o", "t", "s", "x", "c", "l" }, "<Insert>", "<Esc>")
map({ "i", "n", "v", "x", "o", "t", "s", "x", "c", "l" }, "", "<Esc>")

-- Unbind F1 help
map({ "i", "n", "v", "x", "o", "t", "s", "x", "c", "l" }, "<F1>", "<Nop>")
-- Unbind ctrl left click
map({ "i", "n", "v", "x", "o", "t", "s", "x", "c", "l" }, "<C-LeftMouse>", "<Nop>")
-- Unbind tags
map({ "n" }, "<C-t>", "<Nop>")

-- Remap D to blackhole delete
map({ "n", "v" }, "D", '"_d')
-- Remap C to blackhole change
map({ "n", "v" }, "C", '"_c')

-- Map to take current selection and search/replace it
table.unpack = table.unpack or unpack
local function get_visual()
  local _, ls, cs = table.unpack(vim.fn.getpos("v"))
  local _, le, ce = table.unpack(vim.fn.getpos("."))
  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end
vim.keymap.set("v", "<C-r>", function()
  local pattern = table.concat(get_visual())
  pattern = vim.fn.substitute(vim.fn.escape(pattern, "^$.*\\/~[]"), "\n", "\\n", "g")
  vim.api.nvim_input("<Esc>:%s/" .. pattern .. "//g<Left><Left>")
end)

map({ "n" }, "<Backspace>", "^", { desc = "Move to first non-blank character" })

-- Remap paste without losing text
vim.keymap.set("v", "p", '"_dP')

-- Kitty
if os.getenv("TERM") == "xterm-kitty" then
  vim.g.kitty_navigator_no_mappings = 1
  vim.g.tmux_navigator_no_mappings = 1

  vim.cmd([[
    noremap <silent> <c-h> :<C-U>KittyNavigateLeft<cr>
    noremap <silent> <c-l> :<C-U>KittyNavigateRight<cr>
    noremap <silent> <c-j> :<C-U>KittyNavigateDown<cr>
    noremap <silent> <c-k> :<C-U>KittyNavigateUp<cr>
  ]])
end

-- Diff to clipboard
local function compareToClip()
  local ftype = vim.api.nvim_eval("&filetype")
  vim.cmd("vsplit")
  vim.cmd("enew")
  vim.cmd("normal! P")
  vim.cmd("setlocal buftype=nowrite")
  vim.cmd("set filetype=" .. ftype)
  vim.cmd("diffthis")
  vim.cmd([[execute "normal! \<C-w>h"]])
  vim.cmd("diffthis")
end

map({ "n" }, "<leader>D", compareToClip, { desc = "Diff vs clipboard" })
