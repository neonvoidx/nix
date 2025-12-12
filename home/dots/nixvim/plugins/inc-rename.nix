{ pkgs, ... }: {
  programs.nixvim = {

    plugins.inc-rename = { enable = true; };
    keymaps = [{
      key = "<leader>cr";
      action = ":IncRename ";
      options.desc = "Rename symbol";
    }];
  };
}
