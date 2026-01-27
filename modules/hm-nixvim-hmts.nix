{ config, ... }:
{
  flake.modules.homeManager.nixvim-hmts = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      plugins.hmts = {
        enable = true;
      };
    };
  };
}
