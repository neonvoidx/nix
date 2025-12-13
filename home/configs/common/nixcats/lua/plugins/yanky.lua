return {
	"gbprod/yanky.nvim",
	opts = {
		highlight = {
			timer = 200,
		},
	},
	keys = {
		{ "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
		{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
		{ "<c-p>", "<Plug>(YankyCycleForward)" },
		{ "<c-n>", "<Plug>(YankyCycleBackward)" },
		{ "<leader>pp", "<cmd>YankyRingHistory<cr>" },
	},
	event = "BufReadPost",
}
