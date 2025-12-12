return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- Don't run TSUpdate on nix - parsers are managed by nix
		build = function()
			if not require("nixCatsUtils").isNixCats then
				vim.cmd("TSUpdate")
			end
		end,
		dependencies = {
			"RRethy/nvim-treesitter-endwise", -- Auto adds `end` to things like lua functions
			"JoosepAlviste/nvim-ts-context-commentstring", -- Allows commenting in things like HTML inside Vue etc
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {
					enable = true,
					multiwindow = true,
					max_lines = 0,
					separator = "▔",
				},
				keys = {
					{
						"[c",
						function()
							require("treesitter-context").go_to_context(vim.v.count1)
						end,
						{ desc = "Go to Treesitter context" },
					},
				},
			},
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				endwise = {
					enable = true,
				},
				sync_install = false,
				auto_install = false,
				ignore_install = {},
				modules = {},
				highlight = {
					enable = true,
					disable = function(_, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
				},
				-- Don't let treesitter manage parsers on nix
				ensure_installed = {},
			})
		end,
	},
}
