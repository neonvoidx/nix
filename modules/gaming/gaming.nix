{ den, ... }:
{
  den.aspects.gaming =
    { user, ... }:
    {
      includes = [
        den.aspects.steam
        den.aspects.mangohud
        den.aspects.deadlock
        den.aspects.wow
        den.aspects.scopebuddy
      ];

      nixos =
        { pkgs, ... }:
        {
          programs.gamemode = {
            enable = true;
            # nice setting off
            enableRenice = false;
            settings = {
              custom = {
                start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
                end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
              };
            };
          };

          users.users.${user.userName}.extraGroups = [ "gamemode" ];
        };
    };
}
