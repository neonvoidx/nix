{ config, ... }:
{
  flake.modules.homeManager.lazygit = { ... }: {
    programs.lazygit = {
      enable = true;
    };
  };
}
