{ config, ... }:
{
  flake.modules.homeManager.flatpak = { pkgs, lib, config, ... }: {
    home.packages = [ pkgs.flatpak ];
  };
}
