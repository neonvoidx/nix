{ config, ... }:
{
  flake.modules.homeManager.btop = { config, ... }: {
    programs.btop = {
      enable = true;
    };
    programs.zsh.shellAliases = {
      top = "btop";
      htop = "btop";
    };
  };
}
