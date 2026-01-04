-- LSP configuration
local lspconfig = require("lspconfig")

-- Set up borders for hover and signature help
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

-- Common on_attach function
local on_attach = function(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- LSP keymaps
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gr", vim.lsp.buf.references, "Go to references")
  map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "K", vim.lsp.buf.hover, "Hover documentation")
  map("n", "gK", vim.lsp.buf.signature_help, "Signature help")
  map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
  map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format document")
  
  -- Diagnostics
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
  map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
  map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
  map("n", "<leader>cq", vim.diagnostic.setloclist, "Quickfix diagnostics")

  -- Illuminate setup
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- Default capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- LSP servers setup
local servers = {
  "vtsls",
  "eslint",
  "nixd",
  "basedpyright",
  "bashls",
  "biome",
  "clangd",
  "cmake",
  "docker_compose_language_service",
  "dockerls",
  "elixirls",
  "gopls",
  "hyprls",
  "jsonls",
  "lua_ls",
  "rust_analyzer",
}

for _, server in ipairs(servers) do
  local config = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  
  -- Server-specific configurations
  if server == "lua_ls" then
    config.settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
          },
        },
        telemetry = { enable = false },
        diagnostics = {
          globals = { "vim" },
        },
      },
    }
  elseif server == "nixd" then
    config.settings = {
      nixd = {
        formatting = {
          command = { "nixfmt" },
        },
      },
    }
  end
  
  lspconfig[server].setup(config)
end

-- Lazydev setup for Neovim Lua development
require("lazydev").setup({
  library = {
    { path = "luvit-meta/library", words = { "vim%.uv" } },
  },
})
