return {
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "zbirenbaum/copilot-cmp",
    },
    event = "InsertEnter",
    cmd = "Copilot",
    opts = {
      filetypes = {
        markdown = false,
        help = false,
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
            return false
          end
          return true
        end,
      },
      nes = {
        enabled = false,
      },
    },
  },
  {
    "folke/sidekick.nvim",
    ---@class sidekick.Config
    opts = {
      nes = { enabled = false },
      mux = {
        enabled = false,
      },
      nes = {
        enabled = false,
      },
      ---@type table<string, sidekick.cli.Config|{}>
      cli = {
        tools = {
          aider = { cmd = { "ocaider", "--watch-files", "--model oca/gpt5" } },
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle({ name = "copilot" })
        end,
        desc = "Sidekick Toggle Copilot",
      },
      {
        "<leader>aA",
        function()
          require("sidekick.cli").toggle({ name = "aider" })
        end,
        desc = "Sidekick Toggle Aider",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end,
        desc = "Select CLI",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send({ msg = "{this}" })
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      {
        "<c-.>",
        function()
          require("sidekick.cli").focus()
        end,
        mode = { "n", "x", "i", "t" },
        desc = "Sidekick Switch Focus",
      },
    },
  },
}
