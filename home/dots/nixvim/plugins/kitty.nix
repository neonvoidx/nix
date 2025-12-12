{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      kitty-navigator = { enable = true; };
      kitty-scrollback = { enable = true; };
    };
  };
}
