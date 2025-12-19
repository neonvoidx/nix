{ ... }:
{
  programs.nixvim.plugins = {
    trouble = {
      enable = true;
      autoLoad = true;
    };
  };
}
