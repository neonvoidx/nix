{ nixvim, pkgs, ... }:
{
  imports = [
    nixvim.homeModules.nixvim
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    colorscheme = "eldritch";
    imports = [
      ./plugins
      ./opts.nix
      ./keymaps.nix
    ];
  };
}
