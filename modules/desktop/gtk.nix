{ den, ... }:
{
  den.aspects.gtk =
    { host, user, ... }:
    {
      homeManager =
        { osConfig, lib, ... }:
        let
          hasGames = osConfig.fileSystems ? "/games";
          gtk3Bookmarks = [
            "file:///home/${user.userName}/.config"
            "file:///home/${user.userName}/3D"
            "file:///home/${user.userName}/Downloads"
            "file:///home/${user.userName}/Screenshots"
            "file:///home/${user.userName}/Videos"
            "file:///home/${user.userName}/dev"
            "file:///home/${user.userName}/gamedev"
            "file:///home/${user.userName}/nix"
            "file:///home/${user.userName}/pics"
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
    };
}
