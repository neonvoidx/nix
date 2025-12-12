return {
	"stevearc/overseer.nvim",
	opts = {
		templates = {
			"builtin",
			-- "user.cpp_build",
		},
	},
	keys = {
		{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run Task" },
		{ "<leader>ol", "<cmd>OverseerToggle<cr>", desc = "Toggle Task List" },
	},
}
