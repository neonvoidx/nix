{ config, ... }:
{
  flake.modules.homeManager.hyprpolkitagent = { pkgs, lib, config, ... }: {
    services.hyprpolkitagent = {
      enable = true;
    };
  };
}
