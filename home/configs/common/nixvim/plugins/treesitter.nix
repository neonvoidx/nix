{ ... }:
{
  plugins = {
    treesitter = {
      enable = true;
      folding.enable = false;
      nixvimInjections = true;
    };
    treesitter-context = {
      enable = true;
    };
  };
}
