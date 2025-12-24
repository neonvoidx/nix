{ ... }:
{
  plugins.inc-rename = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>cr";
      action = ":IncRename ";
      options.desc = "Rename symbol";
    }
  ];
}
