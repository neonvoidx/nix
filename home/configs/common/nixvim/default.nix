{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
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

}
