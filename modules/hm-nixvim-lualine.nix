{ config, ... }:
{
  flake.modules.homeManager.nixvim-lualine = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      plugins = {
        lualine = {
          enable = true;
        };
      };
    };
  };
}
