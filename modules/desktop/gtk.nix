{ den, ... }:
{
  den.aspects.gtk =
    { host, user, ... }:
    {
      homeManager =
        { pkgs, ... }:
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
                "file:///home/${user.userName}/.config"
                "file:///home/${user.userName}/Downloads"
                "file:///home/${user.userName}/Videos"
                "file:///home/${user.userName}/dev"
                "file:///home/${user.userName}/nix"
                "file:///home/${user.userName}/pics"
              ]
              ++ pkgs.lib.optionals (host.isGaming or false) [
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
        };
    };
}
