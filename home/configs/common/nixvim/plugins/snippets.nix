{ pkgs, ... }:
{
  plugins.friendly-snippets = {
    enable = true;
  };
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "nvim-scissors";
      src = pkgs.fetchFromGitHub {
        owner = "chrisgrieser";
        repo = "nvim-scissors";
        rev = "045b4b3b7b911888671a5bc45a935952f17692dc";
        hash = "sha256-HgAbsbmUzNt0goYiISak6WmUJj0V9ESZolDduUmWEiY=";
      };
      nvimSkipModules = [
        "scissors.2-picker.fzf-lua"
        "scissors.2-picker.telescope"
      ];
    })
  ];

  extraConfigLua = ''
    require("scissors").setup({
      snippetDir = vim.fn.stdpath("config") .. "/snippets",
      editSnippetPopup = {
        height = 0.4,
        width = 0.6,
        border = "rounded",
      },
      backdrop = {
        enabled = true,
      },
      jsonFormatter = "jq",
    })

    local wk = require("which-key")
    wk.add({
      {
        "<leader>S",
        group = "+snippet",
        mode = "v",
        icon = { icon = "✀ " },
      },
    })
  '';

  keymaps = [
    {
      mode = "v";
      key = "<leader>Sa";
      action.__raw = ''
        function()
          require("scissors").addNewSnippet()
        end
      '';
      options = {
        desc = "✀  Add Snippet";
      };
    }
    {
      mode = "n";
      key = "<leader>Se";
      action.__raw = ''
        function()
          require("scissors").editSnippet()
        end
      '';
      options = {
        desc = "✀  Edit Snippet";
      };
    }
  ];
}
