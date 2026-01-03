{ pkgs, ... }:
{
  home.pointerCursor = {
    enable = true;
    package = pkgs.catppuccin-cursors.mochaSapphire;
    name = "catppuccin-mocha-sapphire-cursors";
    dotIcons.enable = true;
    gtk.enable = true;
    size = 26;
    hyprcursor = {
      enable = true;
      size = 26;
    };
    x11 = {
      enable = true;
      defaultCursor = "catppuccin-mocha-sapphire-cursors";
    };
  };
}
