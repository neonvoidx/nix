return {
	{
		"echasnovski/mini.pairs",
		vscode = false,
		opts = {
			modes = { insert = true, command = false, terminal = false },
			markdown = false,
			mappings = {
				-- ['"'] = false,
				-- ["'"] = false,
				-- ["`"] = false,
			},
		},
	},
	{
		"echasnovski/mini.surround",
		opts = {
			mappings = {
				add = "gsa",
				delete = "gsd",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				replace = "gsr",
				update_n_lines = "gsn",
			},
		},
	},
}
