{ pkgs, lib, ... }: {
  programs.nixvim = {
    extraPlugins = [{
      plugin = pkgs.vimUtils.buildVimPlugin {
        name = "eldritch";
        src = pkgs.fetchFromGitHub {
          owner = "eldritch-theme";
          repo = "eldritch.nvim";
          rev = "cddd745d4bd317a5c142708def49fd466fd87fc6";
          hash = "sha256-P8JGhwYrZbvwoJRT6Eli3+Vc9pSowv54Mh1NINHoyzM=";
        };
      };
    }];

    colorscheme = "eldritch";
  };
}
