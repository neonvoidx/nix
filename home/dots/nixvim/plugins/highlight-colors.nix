{ pkgs, ... }: {
  programs.nixvim = {
    plugins.highlight-colors = {
      enable = true;
      settings = { render = "virtual"; };
    };
  };
}
