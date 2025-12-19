{ ... }:
{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      autoLoad = true;
      folding = true;
      nixvimInjections = true;
    };
    treesitter-context = {
      enable = true;
      autoLoad = true;
    };
  };
}
