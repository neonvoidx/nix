return {
  {
    "lewis6991/gitsigns.nvim",
  },
  {
    "f-person/git-blame.nvim",
    -- load the plugin at startup
    event = "VeryLazy",
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin wil only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    opts = {
      -- your configuration comes here
      -- for example
      enabled = true, -- if you want to enable the plugin
      message_template = "<author> • <date> <<sha>>", -- template for the blame message, check the Message template section for more options
      date_format = "%r", -- template for the date, check Date format section for more options
    },
  },
  {
    "declancm/git-scripts.nvim",
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/vault/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/vault/*.md",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      default_keymaps = false,
      commit_on_save = true,
    },
    config = function(_, opts)
      local gitscripts = require("git-scripts")
      gitscripts.setup(opts)

      vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
        callback = function()
          gitscripts.async_pull()
        end,
        desc = "Auto pull repo on enter",
      })
    end,
  },
  {
    "noamsto/resolved.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {},
  },
}
