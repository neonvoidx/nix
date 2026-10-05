{ den, ... }:
{
  den.aspects.noctalia-greeter =
    { host, user, ... }:
    {
      nixos =
        { config, lib, ... }:
        {
          services.displayManager.noctalia-greeter = {
            enable = true;
            extraArgs = [ ];
            passwordlessSyncUsers = [ user.userName ];
            settings = {
              user = {
                default = user.userName;
              };
              output = {
                layout = lib.concatStringsSep "; " (
                  lib.mapAttrsToList (
                    _: monitor: "${monitor.name}:${builtins.replaceStrings [ "x" ] [ "," ] (monitor.position or "0x0")}"
                  ) (host.monitors or { })
                );
              };
              cursor = {
                theme = config.stylix.cursor.name;
                size = config.stylix.cursor.size;
              };
            };
          };

          security.pam.services.greetd.enableGnomeKeyring = true;
        };
    };
}
