{
  # Formatting and linting configuration

  plugins = {
    # Conform - code formatter
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          lua = [ "stylua" ];
          python = [ "isort" "black" ];
          javascript = [ "prettierd" ];
          typescript = [ "prettierd" ];
          javascriptreact = [ "prettierd" ];
          typescriptreact = [ "prettierd" ];
          json = [ "prettierd" ];
          yaml = [ "prettierd" ];
          markdown = [ "prettierd" "markdownlint-cli2" ];
          html = [ "prettierd" ];
          css = [ "prettierd" ];
          scss = [ "prettierd" ];
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
          kdl = [ "kdlfmt" ];
        };
        format_on_save = {
          timeout_ms = 500;
          lsp_fallback = true;
        };
      };
    };

    # Nvim-lint - linting
    lint = {
      enable = true;
      lintersByFt = {
        python = [ "pylint" ];
        javascript = [ "eslint_d" ];
        typescript = [ "eslint_d" ];
        javascriptreact = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
        yaml = [ "yamllint" ];
        cmake = [ "cmakelint" ];
        make = [ "checkmake" ];
        terraform = [ "terraform_validate" ];
        markdown = [ "markdownlint" ];
      };
    };
  };

  # Additional configuration
  extraConfigLua = # lua
    ''
      -- Format keymap
      vim.keymap.set({"n", "v"}, "<leader>cf", function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format file or range (in visual mode)" })

      -- Lint on save
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })

      -- Also lint on enter and text changed
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    '';
}
