{ pkgs, ... }: {
  # Treesitter configuration ported from lua/plugins/treesitter.lua

  plugins = {
    treesitter = {
      enable = true;

      # Grammar packages to install
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        cmake
        cpp
        css
        diff
        html
        javascript
        jsdoc
        json
        jsonc
        latex
        lua
        luadoc
        luap
        markdown
        markdown_inline
        norg
        printf
        python
        query
        regex
        scss
        svelte
        toml
        tsx
        typescript
        typst
        vim
        vimdoc
        vue
        xml
        yaml
      ];

      settings = {
        highlight = {
          enable = true;
          disable = # lua
            ''
              function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                  return true
                end
              end
            '';
        };

        indent = { enable = true; };

        incremental_selection = { enable = true; };
      };

      nixGrammars = true;
    };

    # Treesitter context - sticky header
    treesitter-context = {
      enable = true;
      settings = {
        enable = true;
        multiwindow = true;
        max_lines = 0;
        separator = "▔";
      };
    };

    # Context-aware comments
    ts-context-commentstring = { enable = true; };
  };

  # Additional treesitter plugins via extraPlugins
  extraPlugins = with pkgs.vimPlugins;
    [
      # nvim-treesitter-endwise - Auto adds `end` to things
      nvim-treesitter-endwise
    ];

  # Additional configuration
  extraConfigLua = # lua
    ''
      -- Configure treesitter endwise
      require("nvim-treesitter.configs").setup({
        endwise = {
          enable = true,
        },
      })

      -- Treesitter context keymaps
      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { desc = "Go to Treesitter context" })
    '';
}
