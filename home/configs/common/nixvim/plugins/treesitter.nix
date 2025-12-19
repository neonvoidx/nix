{ ... }:
{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      folding = false;
      nixvimInjections = true;
    };
    treesitter-context = {
      enable = true;
    };
  };
}
