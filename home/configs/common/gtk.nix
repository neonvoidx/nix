{ pkgs, ... }:
{
  gtk = {
    colorScheme = "dark";
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    cursorTheme = {
      name = "catppuccin-mocha-sapphire-cursors";
      package = pkgs.catppuccin-cursors.mochaSapphire;
    };
    font = {
      name = "Roboto Bold";
      size = 13;
    };
    gtk3 = {
      colorScheme = "dark";
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4 = {
      colorScheme = "dark";
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };

  xresources.properties = {
    "Xcursor.size" = 24;
  };
}
