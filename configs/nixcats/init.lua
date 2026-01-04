-- nixcats init.lua
-- Set leader key before any plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load options
require("config.options")

-- Load keymaps
require("config.keymaps")

-- Load plugin configurations
require("config.plugins")
