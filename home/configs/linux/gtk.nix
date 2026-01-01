{ pkgs, config, hostname ? "", nix-colors, ... }:
{
  # Force Home Manager to overwrite existing GTK files
  xdg.configFile."gtk-4.0/gtk.css".force = true;

  gtk = {
    colorScheme = "dark";
    enable = true;
    theme = {
      name = "nix-${config.colorScheme.slug}";
      package = (nix-colors.lib-contrib { inherit pkgs; }).gtkThemeFromScheme { 
        scheme = config.colorScheme;
      };
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
      bookmarks = [
        "file:///synology"
        "file:///home/neonvoid/Downloads"
        "file:///home/neonvoid/.config"
        "file:///home/neonvoid/pics"
      ]
      ++ pkgs.lib.optionals (hostname == "void") [
        "file:///games"
      ];
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
