{ config, ... }:
{
  flake.modules.homeManager.nixvim-guess-indent = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      plugins.guess-indent = {
        enable = true;
      };
    };
  };
}
