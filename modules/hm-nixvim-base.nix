{ config, ... }:
{
  flake.modules.homeManager.nixvim-base = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      colorscheme = "eldritch";

      autoCmd = [
        {
          event = [ "CursorHold" ];
          command = "checktime";
        }
      ];
      nixpkgs = {
        config = {
          allowUnfree = true;
        };
      };
    };
  };
}
