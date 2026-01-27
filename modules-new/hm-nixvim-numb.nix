{ config, ... }:
{
  flake.modules.homeManager.nixvim-numb = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin {
          name = "numb.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "nacro90";
            repo = "numb.nvim";
            rev = "8164fd3d4d0c3ad2b1b111e9a63a59178981b743";
            hash = "sha256-VyvXsjCwSPXqFZle5+4MVS7BvBiA58tR1dTg6ZDTCJ4=";
          };
        })
      ];
    };
  };
}
