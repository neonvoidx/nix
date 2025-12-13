return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile", "BufWritePre" },
  config = function()
    local conform = require("conform")

    vim.g.disable_autoformat = false
    vim.b.format = false

    conform.setup({
      formatters_by_ft = {
        javascript = { "eslint_d", "prettierd" },
        typescript = { "eslint_d", "prettierd" },
        javascriptreact = { "eslint_d", "prettierd" },
        typescriptreact = { "eslint_d", "prettierd" },
        ["javascript.jsx"] = { "eslint_d", "prettierd" },
        ["typescript.tsx"] = { "eslint_d", "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        lua = { "stylua" },
        kdl = { "kdlfmt" },
        python = { "isort", "black" },
        markdown = { "prettierd", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettierd", "markdownlint-cli2", "markdown-toc" },
        nix = { "nixfmt", "nixpkgs-fmt" },
      },
      notify_on_error = false,
      formatters = {
        prettierd = {
          require_cwd = true,
        },
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
    })

    vim.keymap.set("n", "<leader>cf", function()
      if vim.g.disable_autoformat then
        vim.g.disable_autoformat = false
        vim.notify("Autoformat enabled", vim.log.levels.INFO, { title = "Conform" })
      else
        vim.g.disable_autoformat = true
        vim.notify("Autoformat disabled", vim.log.levels.INFO, { title = "Conform" })
      end
    end, { desc = "Toggle format" })

    vim.keymap.set("n", "<leader>cF", function()
      local bufnr = vim.api.nvim_get_current_buf()
      if vim.b[bufnr].disable_autoformat then
        vim.b[bufnr].disable_autoformat = false
        vim.notify("Autoformat enabled (buffer)", vim.log.levels.INFO, { title = "Conform" })
      else
        vim.b[bufnr].disable_autoformat = true

        vim.notify("Autoformat disabled (buffer)", vim.log.levels.INFO, { title = "Conform" })
      end
    end, { desc = "Toggle format (buffer)" })
  end,
}
