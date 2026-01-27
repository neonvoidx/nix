{ config, ... }:
{
  flake.modules.homeManager.nixvim-inc-rename = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
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
    };
  };
}
