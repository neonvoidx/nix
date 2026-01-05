{
  pkgs,
  config,
  hostname ? "",
  nix-colors,
  ...
}:
{
  # Force Home Manager to overwrite existing GTK files
  xdg.configFile."gtk-3.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/gtk.css".force = true;

  gtk = {
    colorScheme = "dark";
    enable = true;
    theme = {
      name = config.colorScheme.slug;
      package = (nix-colors.lib-contrib { inherit pkgs; }).gtkThemeFromScheme {
        scheme = config.colorScheme;
      };
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
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
        "file:///home/neonvoid/nix"
        "file:///home/neonvoid/dev"
        "file:///home/neonvoid/vault"
        "file:///home/neonvoid/homepage"
      ]
      ++ pkgs.lib.optionals (hostname == "void") [
        "file:///games"
        "file:///games/wow"
      ];
    };
    gtk4 = {
      colorScheme = "dark";
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
