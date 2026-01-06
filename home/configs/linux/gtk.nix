{
  lib,
  pkgs,
  hostname ? "",
  ...
}:
{
  # Force Home Manager to overwrite existing GTK files
  xdg.configFile."gtk-3.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/gtk.css".force = true;

  gtk = {
    enable = true;
    gtk3 = {
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
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
