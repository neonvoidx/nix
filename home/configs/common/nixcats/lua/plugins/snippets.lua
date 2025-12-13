return {
	{
		"chrisgrieser/nvim-scissors",
		opts = {
			snippetDir = vim.fn.stdpath("config") .. "/snippets",
		},
		keys = function()
			local wk = require("which-key")
			wk.add({
				{
					"<leader>S",
					group = "+snippet",
					mode = "v",
					icon = { icon = "✀ " },
				},
			})
			return {
				{
					"<leader>Sa",
					function()
						require("scissors").addNewSnippet()
					end,
					desc = "✀  Add Snippet",
					mode = "v",
				},
				{
					"<leader>Se",
					function()
						require("scissors").editSnippet()
					end,
					desc = "✀  Edit Snippet",
				},
			}
		end,
	},
	{
		"rafamadriz/friendly-snippets",
	},
}
