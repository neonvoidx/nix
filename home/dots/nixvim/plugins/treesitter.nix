{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          auto_install = true;
          sync_install = false;
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

      ts-context-commentstring = { enable = true; };
    };

    #  TODO
    # extraPlugins = with pkgs.vimPlugins; [{
    #   plugin = pkgs.vimUtils.buildVimPlugin {
    #     name = "nvim-treesitter-endwise";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "RRethy";
    #       repo = "nvim-treesitter-endwise";
    #       rev = "8b34305ffc28bd75a22f5a0a9928ee726a85c9a6";
    #       hash = "sha256-bmKTQbFhDZ/mvgFg+pGY+0ygXzhSckoS/ByWSKFvpWc=";
    #     };
    #   };
    # }];
    #
    # extraConfigLua = ''
    #   -- Enable treesitter endwise
    #   require("nvim-treesitter.configs").setup({
    #     endwise = {
    #       enable = true,
    #     },
    #   })
    # '';

    keymaps = [{
      key = "[c";
      action.__raw = #lua
        ''
          function()
            require("treesitter-context").go_to_context(vim.v.count1)
          end
        '';
      options.desc = "Go to Treesitter context";
    }];
  };
}
