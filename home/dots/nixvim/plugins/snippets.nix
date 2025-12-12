{ pkgs, ... }: {
  programs.nixvim = {
    plugins.friendly-snippets = { enable = true; };
    # TODO 
    # extraPlugins = with pkgs.vimPlugins; [{
    #   plugin = pkgs.vimUtils.buildVimPlugin {
    #     name = "nvim-scissors";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "chrisgrieser";
    #       repo = "nvim-scissors";
    #       rev = "167c3001abffeb92ca7b4ea72aece654213a357b";
    #       hash = "sha256-2TAQ7VhKSkV1BKKshuNEZEw+9kFp4dzR5kJswa50zwI=";
    #     };
    #   };
    #   config = ''
    #     lua << EOF
    #     require("scissors").setup({
    #       snippetDir = vim.fn.stdpath("config") .. "/snippets",
    #     })
    #     EOF
    #   '';
    # }];
    #
    keymaps = [
      # {
      #   key = "<leader>Sa";
      #   mode = "v";
      #   action.__raw = ''
      #     function()
      #       require("scissors").addNewSnippet()
      #     end
      #   '';
      #   options.desc = "✀  Add Snippet";
      # }
      # {
      #   key = "<leader>Se";
      #   action.__raw = ''
      #     function()
      #       require("scissors").editSnippet()
      #     end
      #   '';
      #   options.desc = "✀  Edit Snippet";
      # }
    ];
  };
}
