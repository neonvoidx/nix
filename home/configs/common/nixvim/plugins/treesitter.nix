{ pkgs, ... }:
{
  programs.nix.plugins.treesitter = {
    enable = true;
    autoLoad = true;
    folding = true;
    nixvimInjections = true;
  };
}
