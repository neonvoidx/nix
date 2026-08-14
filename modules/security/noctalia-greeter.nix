{ den, ... }:
{
  den.aspects.noctalia-greeter =
    { host, user, ... }:
    {
      nixos =
        { pkgs, lib, ... }:
        {
          services.displayManager.noctalia-greeter = {
            enable = true;
            extraArgs = [ ];
            settings = {
              user = {
                default = user.userName;
              };
              output = {
                layout = lib.concatStringsSep "; " (
                  lib.optionals (builtins.hasAttr "monitors" host) (
                    lib.optional (builtins.hasAttr "main" host.monitors) "${host.monitors.secondary.name}:${
                      builtins.replaceStrings [ "x" ] [ "," ] host.monitors.main.position
                    }"
                    ++ lib.optional (builtins.hasAttr "secondary" host.monitors) "${host.monitors.main.name}:${
                      builtins.replaceStrings [ "x" ] [ "," ] host.monitors.secondary.position
                    }"
                  )
                );
              };
              appearance = {
                scheme = "Eldritch";
              };
              cursor = {
                theme = "eldritch-great-old-green-cursors";
                size = 32;
              };
            };
          };

          security.pam.services.greetd.enableGnomeKeyring = true;
        };
    };
}
