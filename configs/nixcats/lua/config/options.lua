-- Neovim options
local opt = vim.opt
local g = vim.g

-- Clipboard
opt.clipboard = "unnamedplus"

-- File handling
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.autoread = true
opt.autowrite = true
opt.confirm = true

-- UI
opt.termguicolors = true
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.signcolumn = "yes"
opt.showmode = false
opt.laststatus = 3
opt.pumblend = 10
opt.pumheight = 10
opt.winminwidth = 5
opt.list = true
opt.smoothscroll = true

-- Indentation
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.shiftround = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.inccommand = "nosplit"

-- Splits
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

-- Scrolling
opt.scrolloff = 4
opt.sidescrolloff = 8

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Folding
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Other
opt.mouse = "nv"
opt.mousemoveevent = true
opt.conceallevel = 1
opt.formatoptions = "jcroqlnt"
opt.timeoutlen = 300
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.wrap = false
opt.autochdir = false
opt.spelllang = "en"
opt.undolevels = 10000

-- Diagnostics configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "󰋼",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
  update_in_insert = true,
  severity_sort = true,
  float = {
    border = "rounded",
    format = function(d)
      return ("%s (%s) [%s]"):format(d.message, d.source, d.code or d.user_data.lsp.code)
    end,
  },
})

-- Autocommands
local function augroup(name)
  return vim.api.nvim_create_augroup("nixcats_" .. name, { clear = true })
end

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("restore_cursor"),
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Check if file changed on focus
vim.api.nvim_create_autocmd("CursorHold", {
  group = augroup("checktime"),
  command = "checktime",
})
