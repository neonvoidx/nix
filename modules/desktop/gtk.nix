{ den, ... }:
{
  den.aspects.gtk.homeManager =
    {
      config,
      osConfig,
      lib,
      ...
    }:
    let
      hasGames = osConfig.fileSystems ? "/games";
      gtk3Bookmarks = [
        "file://${config.xdg.configHome}"
        "file://${config.home.homeDirectory}/3D"
        "file://${config.home.homeDirectory}/Downloads"
        "file://${config.home.homeDirectory}/Screenshots"
        "file://${config.home.homeDirectory}/Videos"
        "file://${config.home.homeDirectory}/dev"
        "file://${config.home.homeDirectory}/gamedev"
        "file://${config.dotfiles.checkoutPath}"
        "file://${config.home.homeDirectory}/pics"
      ]
      ++ lib.optionals hasGames [ "file:///games" ];
    in
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
          bookmarks = gtk3Bookmarks;
        };
        gtk4 = {
          extraConfig = {
            gtk-application-prefer-dark-theme = 1;
          };
        };
      };
    };
}
