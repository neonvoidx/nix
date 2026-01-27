{ config, ... }:
{
  flake.modules.homeManager.hyprshot = { pkgs, lib, config, ... }: {
    programs.hyprshot = {
      enable = true;
      saveLocation = "$HOME/Screenshots";
    };
  };
}
