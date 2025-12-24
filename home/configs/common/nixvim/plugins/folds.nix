{ ... }:
{
  plugins.nvim-ufo = {
    enable = true;
    settings = {
      provider_selector = ''
        function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end
      '';
    };
  };

  opts = {
    foldcolumn = "1";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "zR";
      action.__raw = ''
        function()
          require("ufo").openAllFolds()
        end
      '';
      options.desc = "Open all folds";
    }
    {
      mode = "n";
      key = "zM";
      action.__raw = ''
        function()
          require("ufo").closeAllFolds()
        end
      '';
      options.desc = "Close all folds";
    }
  ];
}
