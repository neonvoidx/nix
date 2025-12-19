{ nixvim, pkgs, ... }:
{
  imports = [
    nixvim.homeModules.nixvim
    ./plugins
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    colorscheme = "eldritch";
  };
}
