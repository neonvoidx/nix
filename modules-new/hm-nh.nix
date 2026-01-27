{ config, ... }:
{
  flake.modules.homeManager.nh = { pkgs, lib, config, ... }: {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "weekly";
      };
      flake = "$HOME/nix";
      homeFlake = "$HOME/nix";
      osFlake = "$HOME/nix";
    };
  };
}
