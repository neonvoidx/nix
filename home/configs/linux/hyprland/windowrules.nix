{
  lib,
  hostname ? "",
  ...
}:
let
  isVoid = hostname == "void";
  isVoidFrame = hostname == "voidframe";
in
{
  windowrule = [
    "workspace 3 silent,class:^(vesktop)$"
    "workspace 2 silent,title:^(Stream Deck UI)$"
    "workspace 10 silent,class:^(steam|Steam)$"
    "workspace 10 silent,title:^(Steamwebhelper)$"
    "float,initialTitle:^(Sign in to Steam)$"
    "float,class:^(SGDBoop)$"
    "center,initialTitle:^(Sign in to Steam)$"
    "pin,class:^(hyprland-dialog)$"
    "suppressevent activatefocus,class:^(steam)$"
    "workspace 11,class:^(gamescope)$"
  ]
  ++ lib.optionals isVoid [
    "workspace 3 silent,class:^(spotify)$"
    "workspace 4 silent,class:^(org.mozilla.Thunderbird)$"
    "workspace 4 silent,class:^(org.gnome.Fractal)$"
  ]
  ++ lib.optionals isVoidFrame [
    "workspace 4 silent,class:^(spotify)$"
  ];

  windowrulev2 = [
    # Battle.net
    "float,title:^(Battle.net)$"
    "workspace 11,title:^(Battle.net)$"
    # World of Warcraft
    "fullscreen,title:^(World of Warcraft)$"
    "workspace 11,title:^(World of Warcraft)$"
    # Thunderbird reminders
    "suppressevent activatefocus,class:^(org.mozilla.Thunderbird)$,title:^(.*Reminder.*)$"
    "float,class:^(org.mozilla.Thunderbird)$,title:^(.*Reminder.*)$"
    "pin,class:^(org.mozilla.Thunderbird)$,title:^(.*Reminder.*)$"
    "size 20% 30%,class:^(org.mozilla.Thunderbird)$,title:^(.*Reminder.*)$"
    "move 100%-20%-10 100%-30%-10,class:^(org.mozilla.Thunderbird)$,title:^(.*Reminder.*)$"
    # Quick kitty terminal
    "float,class:^(kittyquick)$"
    "pin,class:^(kittyquick)$"
    # Firefox Picture-in-Picture
    "suppressevent activatefocus,class:^(firefox)$,title:^(Picture-in-Picture)$"
    "nofocus,class:^(firefox)$,title:^(Picture-in-Picture)$"
    "float,class:^(firefox)$,title:^(Picture-in-Picture)$"
    "pin,class:^(firefox)$,title:^(Picture-in-Picture)$"
    "size 20% 30%,class:^(firefox)$,title:^(Picture-in-Picture)$"
    "move 100%-20%-10 100%-30%-10,class:^(firefox)$,title:^(Picture-in-Picture)$"
  ];

  layerrule = [ "noscreenshare,namespace:^(noctalia-notifications.*)$" ];
}
