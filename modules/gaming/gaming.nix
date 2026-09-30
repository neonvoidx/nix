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
        let
          notifySend = "${pkgs.libnotify}/bin/notify-send";
          noctaliaMsg = "${pkgs.noctalia}/bin/noctalia msg";
        in
        {
          programs.gamemode = {
            enable = true;
            # nice setting off
            enableRenice = false;
            settings = {
              custom = {
                start = "${notifySend} 'GameMode started' && ${noctaliaMsg} notification-dnd-set on";
                end = "${notifySend} 'GameMode ended' && ${noctaliaMsg} notification-dnd-set off";
              };
            };
          };

          users.users.${user.userName}.extraGroups = [ "gamemode" ];
        };
    };
}
