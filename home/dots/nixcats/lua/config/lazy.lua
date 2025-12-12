-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	{ import = "plugins" },
}, {
	checker = { enabled = true, concurrency = 1 },
	change_detection = { enabled = true, notify = false },
	ui = {
		size = { width = 0.8, height = 0.8 },
		border = "rounded",
		backdrop = 50,
		title = "Lazy",
		title_pos = "left",
	},
	git = {
		log = { "-1" },
	},
	rocks = {
		enabled = true,
		hererocks = nil,
	},
	install = {
		missing = true,
		colorscheme = { "eldritch" },
	},
	-- Don't write lockfile when using nixCats (config is read-only from nix store)
	lockfile = require("nixCatsUtils").isNixCats and vim.fn.stdpath("data") .. "/lazy-lock.json"
		or vim.fn.stdpath("config") .. "/lazy-lock.json",
	-- Disable change detection for config dir on nixCats (it's in the nix store)
	change_detection = {
		enabled = not require("nixCatsUtils").isNixCats,
		notify = false,
	},
})

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { silent = true })
