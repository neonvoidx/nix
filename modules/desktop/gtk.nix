{ ... }:
{
  flake.modules.homeManager.gtk =
    {
      lib,
      pkgs,
      osConfig ? null,
      ...
    }:
    let
      hostname = if osConfig != null then osConfig.networking.hostName else "";
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
          bookmarks = [
            "file:///synology"
            "file:///home/neonvoid/.config"
            "file:///home/neonvoid/Downloads"
            "file:///home/neonvoid/Videos"
            "file:///home/neonvoid/dev"
            "file:///home/neonvoid/homepage"
            "file:///home/neonvoid/nix"
            "file:///home/neonvoid/pics"
            "file:///home/neonvoid/vault"
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
    };
}
