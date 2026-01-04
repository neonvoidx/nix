-- Plugin configurations
-- Load all plugin configurations

-- Core plugins
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.completion")

-- UI plugins
require("plugins.colorscheme")
require("plugins.lualine")
require("plugins.bufferline")
require("plugins.noice")
require("plugins.whichkey")

-- Navigation
require("plugins.flash")
require("plugins.yazi")

-- Editing
require("plugins.mini")
require("plugins.yanky")
require("plugins.comments")
require("plugins.autopairs")

-- Git
require("plugins.gitsigns")
require("plugins.diffview")

-- Formatting and linting
require("plugins.conform")
require("plugins.lint")

-- Other utilities
require("plugins.snacks")
