{ config, ... }:
{
  flake.modules.homeManager.nixvim-quickfix = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin {
          name = "quicker.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "stevearc";
            repo = "quicker.nvim";
            rev = "771437c3e3672dba9233156e1c2e2fc1888a5fff";
            hash = "sha256-ce4UxGfM09hh5Z0LN0f9oFTrp0r5TzEi7dkxfuXZmf0=";
          };
        })
      ];
    };
  };
}
