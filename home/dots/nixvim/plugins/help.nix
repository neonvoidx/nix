{ pkgs, ... }: { programs.nixvim = { plugins.helpview = { enable = true; }; }; }
