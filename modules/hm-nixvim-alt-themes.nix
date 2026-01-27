{ config, ... }:
{
  flake.modules.homeManager.nixvim-alt-themes = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha"; # latte, frappe, macchiato, mocha
        };
      };

      colorschemes.tokyonight = {
        enable = true;
        settings = {
          style = "night"; # storm, night, moon, day
        };
      };

      colorschemes.dracula = {
        enable = true;
      };

      colorschemes.onedark = {
        enable = true;
      };

      colorschemes.nightfox = {
        enable = true;
        flavor = "carbonfox"; # nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox
      };
    };
  };
}
