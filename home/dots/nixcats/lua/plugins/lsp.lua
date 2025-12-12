return {
	--  _     ____  ____
	-- | |   / ___||  _ \
	-- | |   \___ \| |_) |
	-- | |___ ___) |  __/
	-- |_____|____/|_|
	--
	{
		"RRethy/vim-illuminate",
		-- Auto highlights for LSP -> treesitter -> regex same words/symbols
		opts = {
			providers = { "lsp", "treesitter", "regex" },
		},
		config = function(_, opts)
			require("illuminate").configure(opts)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = true,
		},
		config = function()
			vim.lsp.config("vtsls", {
				settings = {
					complete_function_calls = true,
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							maxInlayHintLength = 30,
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = true,
						},
						inlayHints = {
							enumMemberValues = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							variableTypes = { enabled = false },
						},
						preferences = {
							importModuleSpecifier = "relative",
						},
					},
				},
			})

			vim.lsp.config("clangd", {
				keys = {
					{ "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
				},
				root_markers = {
					"compile_commands.json",
					"compile_flags.txt",
					"configure.ac", -- AutoTools
					"Makefile",
					"configure.ac",
					"configure.in",
					"config.h.in",
					"meson.build",
					"meson_options.txt",
					"build.ninja",
					".git",
				},
				capabilities = {
					offsetEncoding = { "utf-16" },
				},
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = true,
					clangdFileStatus = true,
				},
				setup = {
					clangd = function(_, opts)
						local clangd_ext_opts = {
							inlay_hints = {
								inline = false,
							},
							ast = {
								--These require codicons (https://github.com/microsoft/vscode-codicons)
								role_icons = {
									type = "",
									declaration = "",
									expression = "",
									specifier = "",
									statement = "",
									["template argument"] = "",
								},
								kind_icons = {
									Compound = "",
									Recovery = "",
									TranslationUnit = "",
									PackExpansion = "",
									TemplateTypeParm = "",
									TemplateTemplateParm = "",
									TemplateParamObject = "",
								},
							},
						}
						require("clangd_extensions").setup(
							vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts })
						)
						return false
					end,
				},
			})

			--  _     ____  ____    _  __
			-- | |   / ___||  _ \  | |/ /___ _   _ _ __ ___   __ _ _ __  ___
			-- | |   \___ \| |_) | | ' // _ \ | | | '_ ` _ \ / _` | '_ \/ __|
			-- | |___ ___) |  __/  | . \  __/ |_| | | | | | | (_| | |_) \__ \
			-- |_____|____/|_|     |_|\_\___|\__, |_| |_| |_|\__,_| .__/|___/
			--                               |___/                |_|
			local wk = require("which-key")
			wk.add({
				{
					"<leader>c",
					group = "+code",
					icon = { icon = " " },
				},
			})

			vim.keymap.set("n", "<space>cd", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
			vim.keymap.set("n", "[e", function()
				vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
			end, { desc = "Jump to the previous diagnostic error" })
			vim.keymap.set("n", "]e", function()
				vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
			end, { desc = "Jump to the next diagnostic error" })
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings.
					local opts = { buffer = ev.buf }
					vim.keymap.set(
						"n",
						"gD",
						vim.lsp.buf.declaration,
						vim.tbl_extend("force", opts, { desc = "Goto declaration" })
					)
					vim.keymap.set(
						"n",
						"gd",
						vim.lsp.buf.definition,
						vim.tbl_extend("force", opts, { desc = "Goto definition" })
					)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
					vim.keymap.set(
						"n",
						"gi",
						vim.lsp.buf.implementation,
						vim.tbl_extend("force", opts, { desc = "Implementation" })
					)

					vim.keymap.set(
						{ "n", "v" },
						"<space>ca",
						vim.lsp.buf.code_action,
						vim.tbl_extend("force", opts, { desc = "Code action" })
					)
					vim.keymap.set({ "n", "v" }, "<space>cA", function()
						vim.lsp.buf.code_action({
							apply = true,
							context = {
								only = { "source" },
								diagnostics = {},
							},
						})
					end, vim.tbl_extend("force", opts, { desc = "Code action (buffer)" }))
					vim.keymap.set(
						{ "n" },
						"<leader>li",
						"<cmd>LspInfo<cr>",
						vim.tbl_extend("force", opts, { desc = "LSP Info" })
					)
					vim.keymap.set(
						{ "n" },
						"<leader>ll",
						"<cmd>LspLog<cr>",
						vim.tbl_extend("force", opts, { desc = "LSP Logs" })
					)
					vim.keymap.set(
						{ "n" },
						"<leader>r",
						"<cmd>LspRestart<cr>",
						vim.tbl_extend("force", opts, { desc = "LSP Restart" })
					)
					-- End of lsp attach autocmd
				end,
			})

			--     _         _                           _
			--    / \  _   _| |_ ___   ___ _ __ ___   __| |___
			--   / _ \| | | | __/ _ \ / __| '_ ` _ \ / _` / __|
			--  / ___ \ |_| | || (_) | (__| | | | | | (_| \__ \
			-- /_/   \_\__,_|\__\___/ \___|_| |_| |_|\__,_|___/
			--
			-- vim.api.nvim_create_autocmd("BufWritePre", {
			--   group = vim.api.nvim_create_augroup("organize_imports", { clear = true }),
			--   pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
			--   callback = function()
			--     vim.lsp.buf.code_action({
			--       apply = true,
			--       context = { only = { "source.addMissingImports" }, diagnostics = {} },
			--     })
			--     -- Doesn't work well with both, have to save twice in a row for both to work
			--     -- vim.lsp.buf.code_action({ apply = true, context = { only = { "source.removeUnused.ts" }, diagnostics = {} } })
			--   end,
			-- })

			-- End of config function
		end,
	},
	--  __  __
	-- |  \/  | __ _ ___  ___  _ __
	-- | |\/| |/ _` / __|/ _ \| '_ \
	-- | |  | | (_| \__ \ (_) | | | |
	-- |_|  |_|\__,_|___/\___/|_| |_|
	--
	-- {
	--   "mason-org/mason.nvim",
	--   dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
	--   config = function()
	--     local mason = require("mason")
	--     local tool = require("mason-tool-installer")
	--
	--     mason.setup({
	--       ui = {
	--         icons = {
	--           package_installed = "✓",
	--           package_pending = "➜",
	--           package_uninstalled = "✗",
	--         },
	--       },
	--     })
	--
	--     tool.setup({
	--       ensure_installed = {
	--         -- LSP
	--         "bashls",
	--         "jsonls",
	--         "gopls",
	--         "lua_ls",
	--         "basedpyright",
	--         "yamlls",
	--         "docker_compose_language_service",
	--         "dockerls",
	--         "neocmake",
	--         "vtsls",
	--         "terraformls",
	--         "clangd",
	--         "zls",
	--         "emmet_language_server",
	--         "fish_lsp",
	--         -- Linters
	--         "mmdc",
	--         "pylint",
	--         "eslint_d",
	--         "checkmake",
	--         "terraform",
	--         "yamllint",
	--         "cmakelint",
	--         "cmakelang",
	--         -- DAP
	--         "codelldb",
	--         -- Formatters
	--         "stylua",
	--         "isort",
	--         "black",
	--         "prettierd",
	--         "markdownlint-cli2",
	--         "markdown-toc",
	--         "kdlfmt",
	--       },
	--     })
	--   end,
	--   keys = {
	--     { "<leader>lm", "<cmd>Mason<cr>", { desc = "Mason" } },
	--   },
	-- },
	-- {
	--   "mason-org/mason-lspconfig.nvim",
	--   opts = {
	--     automatic_enable = true,
	--   },
	--   dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
	-- },

	--  ____  _                             _   _
	-- |  _ \(_) __ _  __ _ _ __   ___  ___| |_(_) ___ ___
	-- | | | | |/ _` |/ _` | '_ \ / _ \/ __| __| |/ __/ __|
	-- | |_| | | (_| | (_| | | | | (_) \__ \ |_| | (__\__ \
	-- |____/|_|\__,_|\__, |_| |_|\___/|___/\__|_|\___|___/
	--                |___/
	{
		"folke/trouble.nvim",
		opts = {
			modes = {
				diagnostics_buffer = {
					mode = "diagnostics", -- inherit from diagnostics mode
					preview = {
						type = "float",
						relative = "editor",
						border = "rounded",
						title = "Preview",
						title_pos = "center",
						position = { 0, -2 },
						size = { width = 0.4, height = 0.4 },
						zindex = 200,
					},
					filter = {
						buf = 0,
					},
				},
			},
		}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = function()
			local wk = require("which-key")
			wk.add({
				{
					"<leader>x",
					group = "+trouble",
					icon = { icon = " " },
				},
			})
			return {
				{
					"<leader>xX",
					"<cmd>Trouble diagnostics toggle<cr>",
					desc = "Diagnostics (Trouble)",
				},
				{
					"<leader>xx",
					"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
					desc = "Buffer Diagnostics (Trouble)",
				},
				{
					"<leader>cs",
					"<cmd>Trouble symbols toggle focus=false<cr>",
					desc = "Symbols (Trouble)",
				},
				{
					"<leader>cl",
					"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
					desc = "LSP Definitions / references / ... (Trouble)",
				},
				{
					"<leader>xl",
					"<cmd>Trouble loclist toggle<cr>",
					desc = "Location List (Trouble)",
				},
				{
					"<leader>xq",
					"<cmd>Trouble qflist toggle<cr>",
					desc = "Quickfix List (Trouble)",
				},
			}
		end,
	},

	--  _                    ____
	-- | |    __ _ _____   _|  _ \  _____   __
	-- | |   / _` |_  / | | | | | |/ _ \ \ / /
	-- | |__| (_| |/ /| |_| | |_| |  __/\ V /
	-- |_____\__,_/___|\__, |____/ \___| \_/
	--                 |___/
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false,
	},
	{
		"p00f/clangd_extensions.nvim",
		lazy = true,
		opts = {},
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup({
				options = {
					show_source = {
						enabled = true,
					},
					multilines = {
						enabled = true,
					},
					add_messages = {
						display_count = true,
					},
				},
			})
			vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
		end,
	},
	{
		"onsails/lspkind.nvim",
		opts = {
			preset = "default",
			mode = "symbol",
		},
	},
}
