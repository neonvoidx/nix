{ config, ... }:
{
  flake.modules.homeManager.nixvim-session = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      plugins.persistence = {
        enable = true;
        settings = {
          need = 1;
          branch = true;
        };
      };
    };
  };
}
