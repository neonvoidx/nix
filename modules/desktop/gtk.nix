{ den, ... }:
{
  den.aspects.gtk =
    { host, user, ... }:
    {
      homeManager =
        { pkgs, osConfig, ... }:
        let
          systemMounts = [
            "/"
            "/boot"
            "/nix"
            "/proc"
            "/sys"
            "/dev"
            "/run"
            "/tmp"
          ];
          # Dynamically add bookmarks for Thunar for non system mounts
          extraFsBookmarks = map (mp: "file://${mp}") (
            builtins.filter (mp: !builtins.elem mp systemMounts) (builtins.attrNames osConfig.fileSystems)
          );
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
                "file:///home/${user.userName}/.config"
                "file:///home/${user.userName}/.local/share/Trash/files Trash"
                "file:///home/${user.userName}/3D"
                "file:///home/${user.userName}/Downloads"
                "file:///home/${user.userName}/Screenshots"
                "file:///home/${user.userName}/Videos"
                "file:///home/${user.userName}/dev"
                "file:///home/${user.userName}/gamedev"
                "file:///home/${user.userName}/nix"
                "file:///home/${user.userName}/pics"
                "file:///synology"
              ]
              ++ extraFsBookmarks;
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
