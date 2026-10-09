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
          # gamemode's INI parser truncates lines to 200 bytes, so the raw
          # command lines must stay short; wrapping keeps them well under it.
          gamemodeHook = pkgs.writeShellScript "gamemode-hook" ''
            ${notifySend} "$1"
            ${noctaliaMsg} notification-dnd-set "$2"
          '';
        in
        {
          programs.gamemode = {
            enable = true;
            # nice setting off
            enableRenice = false;
            settings = {
              custom = {
                start = "${gamemodeHook} 'Gamemode and DND enabled' on";
                end = "${gamemodeHook} 'Gamemode and DND disabled' off";
              };
            };
          };

          users.users.${user.userName}.extraGroups = [ "gamemode" ];
        };
    };
}
