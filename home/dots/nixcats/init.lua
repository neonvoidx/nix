require("nixCatsUtils").setup({
	non_nix_value = true,
})
-- require("nixCatsUtils.lazyCat").setup(nixCats.pawsible({ "allPlugins", "start", "lazy.nvim" }), lazySpec, opts)

if require("nixCatsUtils").isNixCats then
	vim.notify("Using nixCats.. meow 🐱️!")
end

require("config.autocmds")
require("config.opts")
require("config.lazy")
require("config.keymaps")
