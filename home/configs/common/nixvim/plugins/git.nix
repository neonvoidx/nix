{ pkgs, ... }:
{
  plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add.text = "+";
        change.text = "~";
        delete.text = "_";
        topdelete.text = "‾";
        changedelete.text = "~";
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    git-blame-nvim
  ];

  extraConfigLua = ''
    -- git-blame.nvim configuration
    vim.g.gitblame_enabled = true
    vim.g.gitblame_message_template = '<author> • <date> <<sha>>'
    vim.g.gitblame_date_format = '%r'
  '';
}
