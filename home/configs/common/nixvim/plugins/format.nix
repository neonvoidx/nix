{ ... }:
{
  plugins.conform-nvim = {
    enable = true;
    autoInstall = {
      enable = true;
      overrides.markdown-toc = null;
    };
    settings = {
      formatters_by_ft = {
        javascript = [
          "eslint_d"
          "prettierd"
        ];
        typescript = [
          "eslint_d"
          "prettierd"
        ];
        javascriptreact = [
          "eslint_d"
          "prettierd"
        ];
        typescriptreact = [
          "eslint_d"
          "prettierd"
        ];
        "javascript.jsx" = [
          "eslint_d"
          "prettierd"
        ];
        "typescript.tsx" = [
          "eslint_d"
          "prettierd"
        ];
        css = [ "prettierd" ];
        html = [ "prettierd" ];
        json = [ "prettierd" ];
        yaml = [ "prettierd" ];
        lua = [ "stylua" ];
        kdl = [ "kdlfmt" ];
        python = [
          "isort"
          "black"
        ];
        markdown = [
          "prettierd"
          "markdownlint-cli2"
          "markdown-toc"
        ];
        "markdown.mdx" = [
          "prettierd"
          "markdownlint-cli2"
          "markdown-toc"
        ];
        nix = [ "nixfmt" ];
      };
      format_on_save = # lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end


            return { timeout_ms = 2000, lsp_fallback = true }, on_format
           end
        '';
      notify_on_error = false;
      notify_no_formatters = false;
    };
  };

  keymaps = [
    {
      key = "<leader>cf";
      action.__raw = ''
        function()
             if vim.g.disable_autoformat then
               vim.g.disable_autoformat = false
               vim.notify("Autoformat enabled", vim.log.levels. INFO, { title = "Conform" })
             else
               vim.g.disable_autoformat = true
               vim.notify("Autoformat disabled", vim.log. levels.INFO, { title = "Conform" })
             end
        end
      '';
      options = {
        silent = true;
        desc = "Toggle format";
      };
      mode = [ "n" ];
    }
    {
      key = "<leader>cF";
      action.__raw = ''
        function()
             local bufnr = vim. api.nvim_get_current_buf()
             if vim. b[bufnr].disable_autoformat then
               vim.b[bufnr].disable_autoformat = false
               vim.notify("Autoformat enabled (buffer)", vim.log.levels.INFO, { title = "Conform" })
             else
               vim.b[bufnr].disable_autoformat = true

               vim.notify("Autoformat disabled (buffer)", vim.log.levels.INFO, { title = "Conform" })
             end
        end
      '';
      options = {
        silent = true;
        desc = "Toggle format (buffer)";
      };
      mode = [ "n" ];
    }
  ];
}
