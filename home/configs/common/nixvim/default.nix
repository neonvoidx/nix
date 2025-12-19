{ nixvim, pkgs, ... }:
{
  imports = [ nixvim.homeModules.nixvim ];
  programs.nixvim = {
    enable = true;
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "eldritch.nvim";
        src = pkgs.fetchFromGithub {
          owner = "eldritch-theme";
          repo = "eldritch.nvim";
          rev = "d153de7a8a269792b75d85ef0edee2761d7c7ac5";
          hash = "";
        };
      })
    ];
  };
}
