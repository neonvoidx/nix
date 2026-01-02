{ lib, pkgs, ... }:
let
  servers = [
    "vtsls"
    "eslint"
    "nixd"
    "basedpyright"
    "bashls"
    "biome"
    "clangd"
    "cmake"
    "docker_compose_language_server"
    "dockerls"
    "elixirls"
    "gopls"
    "hyprls"
    "jsonls"
    "lua_ls"
    "qmlls"
    "rust_analyzer"
    "stylua"
  ];
in
{
  plugins.lspconfig.enable = true;

  # Additional LSP plugins
  plugins.lazydev = {
    enable = true;
    settings = {
      library = [
        {
          path = "\${3rd}/luv/library";
          words = [ "vim%.uv" ];
        }
      ];
    };
  };

  plugins.rustaceanvim = {
    enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    vim-illuminate
    lspkind-nvim
  ];

  extraConfigLua = ''
    -- vim-illuminate configuration
    require("illuminate").configure({
      providers = { "lsp", "treesitter", "regex" },
    })

    -- lspkind configuration
    require("lspkind").init({
      preset = "default",
      mode = "symbol",
    })
  '';

  lsp = {
    servers = {
      "*" = {
        config = {
          capabilities = {
            textDocument = {
              semanticTokens = {
                multilineTokenSupport = true;
              };
            };
          };
          root_markers = [
            ".git"
          ];
        };
      };
    }
    // lib.genAttrs servers (_: {
      enable = true;
    });
  };

  keymaps = [
    {
      mode = "n";
      key = "<space>cd";
      action.__raw = "vim.diagnostic.open_float";
      options.desc = "Open diagnostic float";
    }
    {
      mode = "n";
      key = "[e";
      action.__raw = ''
        function()
          vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
        end
      '';
      options.desc = "Jump to the previous diagnostic error";
    }
    {
      mode = "n";
      key = "]e";
      action.__raw = ''
        function()
          vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
        end
      '';
      options.desc = "Jump to the next diagnostic error";
    }
  ];

  autoCmd = [
    {
      event = "LspAttach";
      callback.__raw = ''
        function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Goto declaration" }))
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto definition" }))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Implementation" }))
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
          vim.keymap.set({ "n", "v" }, "<space>cA", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source" },
                diagnostics = {},
              },
            })
          end, vim.tbl_extend("force", opts, { desc = "Code action (buffer)" }))
          vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", vim.tbl_extend("force", opts, { desc = "LSP Info" }))
          vim.keymap.set("n", "<leader>ll", "<cmd>LspLog<cr>", vim.tbl_extend("force", opts, { desc = "LSP Logs" }))
          vim.keymap.set("n", "<leader>r", "<cmd>LspRestart<cr>", vim.tbl_extend("force", opts, { desc = "LSP Restart" }))
        end
      '';
    }
  ];
}
