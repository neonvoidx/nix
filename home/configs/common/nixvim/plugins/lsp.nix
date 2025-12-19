{ ... }:
{
  programs.nixvim.plugins = {
    lspconfig = {
      enable = true;
      autoLoad = true;
    };
  };
}
