return {
	"mikavilpas/yazi.nvim",
	version = "*", -- use the latest stable version
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	keys = {
		-- 👇 in this section, choose your own keymappings!
		{
			"<leader>e",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Yazi (current location)",
		},
		{
			-- Open in the current working directory
			"<leader>E",
			"<cmd>Yazi cwd<cr>",
			desc = "Yazi (cwd)",
		},
	},
	opts = {
		-- if you want to open yazi instead of netrw, see below for more info
		open_for_directories = true,
		pick_window_implementation = "snacks.picker",
		integrations = {
			grep_in_directory = "snacks.picker",
		},
		keymaps = {
			show_help = "<f1>",
		},
	},
	init = function()
		vim.g.loaded_netrwPlugin = 1
	end,
}
