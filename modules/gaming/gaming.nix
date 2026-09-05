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
        { ... }:
        {
          programs.gamemode = {
            enable = true;
            # nice setting off
            enableRenice = false;
          };

          users.users.${user.userName}.extraGroups = [ "gamemode" ];
        };
    };
}
