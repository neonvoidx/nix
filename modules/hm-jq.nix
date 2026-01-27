{ config, ... }:
{
  flake.modules.homeManager.jq = { ... }: {
    programs.jq = {
      enable = true;
    };
  };
}
