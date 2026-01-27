{ config, ... }:
{
  flake.modules.homeManager.clipboard = { pkgs, lib, config, ... }: {
    services.cliphist = {
      enable = true;
    };
    services.wl-clip-persist = {
      enable = true;
    };
  };
}
