{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          auto_install = true;
          sync_install = false;
          ensure_installed = [
            "css"
            "latex"
            "norg"
            "scss"
            "svelte"
            "typst"
            "vue"
            "bash"
            "c"
            "cpp"
            "cmake"
            "diff"
            "html"
            "javascript"
            "jsdoc"
            "json"
            "jsonc"
            "lua"
            "luadoc"
            "luap"
            "markdown"
            "markdown_inline"
            "printf"
            "python"
            "query"
            "regex"
            "toml"
            "tsx"
            "typescript"
            "vim"
            "vimdoc"
            "xml"
            "yaml"
          ];
        };
      };

      treesitter-context = {
        enable = true;
        settings = {
          enable = true;
          multiwindow = true;
          max_lines = 0;
          separator = "▔";
        };
      };

      ts-context-commentstring = {
        enable = true;
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-treesitter-endwise";
          src = pkgs.fetchFromGitHub {
            owner = "RRethy";
            repo = "nvim-treesitter-endwise";
            rev = "8b34305ffc28bd75a22f5a0a9928ee726a85c9a6";
            hash = "sha256-/jNeJkl2R5OzvN0SnA1KqcN+/5Hiq/lQxLI/P23hFvs=";
          };
        };
      }
    ];

    extraConfigLua = ''
      -- Enable treesitter endwise
      require("nvim-treesitter.configs").setup({
        endwise = {
          enable = true,
        },
      })
    '';

    keymaps = [
      {
        key = "[c";
        action.__raw = ''
          function()
            require("treesitter-context").go_to_context(vim.v.count1)
          end
        '';
        options.desc = "Go to Treesitter context";
      }
    ];
  };
}
