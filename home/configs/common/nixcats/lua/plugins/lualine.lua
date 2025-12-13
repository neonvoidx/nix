return {
  "nvim-lualine/lualine.nvim",
  vscode = false,
  dependences = {
    "f-person/git-blame.nvim"
  },
  opts = function()
    vim.g.gitblame_display_virtual_text = 0
    local git_blame = require("gitblame")

    local opts = {
      options = {
        theme = "eldritch",
        component_separators = "",
        section_separators = { left = "", right = "" },
        icons_enabled = true,
        globalstatus = true,
        refresh = { statusline = 1000, tabline = 1000 },
        disabled_filetypes = { statusline = { "dashboard" }, tabline = { "dashboard" } },
      },
      extensions = { "lazy" },
      sections = {
        lualine_a = { { "mode", separator = { left = "", right = "" } } },
        lualine_b = { "branch" },
        lualine_c = {
          { "filename", file_status = true, newfile_status = true, path = 0, shorting_target = 40 },
          { "diff", symbols = { added = " ", modified = "󰣕 ", removed = " " } },
          "diagnostics",
        },
        lualine_x = {
          {
            require("noice").api.status.mode.get,
            cond = require("noice").api.status.mode.has,
            color = { fg = "#ff9e64" },
          },
          {
            git_blame.get_current_blame_text,
            cond = git_blame.is_blame_text_available,
          },
          {
            "overseer",
          },
          -- { codeCompanion() },
          {
            function()
              return " "
            end,
            color = function()
              local status = require("sidekick.status").get()
              if status then
                return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
              end
            end,
            cond = function()
              local status = require("sidekick.status")
              return status.get() ~= nil
            end,
          },
          {
            function()
              local status = require("sidekick.status").cli()
              return " " .. (#status > 1 and #status or "")
            end,
            cond = function()
              return #require("sidekick.status").cli() > 0
            end,
            color = function()
              return "Special"
            end,
          },
        },
        lualine_y = {
          "filetype",
          { "location" },
        },
        lualine_z = {
          {
            function()
              local lazyStatus = require("lazy.status")
              local has_updates = lazyStatus.has_updates
              local packages = require("lazy.status").updates
              if has_updates() then
                return "󱧕 " .. packages
              else
                return "󰏗 󰄵"
              end
            end,
          },
        },
      },
    }

    return opts
  end,
  dependencies = { "nvim-tree/nvim-web-devicons", "eldritch-theme/eldritch.nvim" },
}
