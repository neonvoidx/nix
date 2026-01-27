{ config, ... }:
{
  flake.modules.homeManager.nixvim-treesitter = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      plugins = {
        treesitter = {
          enable = true;
          folding.enable = false;
          nixvimInjections = true;
        };
        treesitter-context = {
          enable = true;
        };
      };
    };
  };
}
