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
    {
      name = "vesktop";
      "match:class" = "gcr-prompter";
      float = "on";
      pin = "on";
    }
    {
      name = "vesktop";
      "match:class" = "vesktop";
      workspace = "3 silent";
    }
    {
      name = "steampopup";
      "match:title" = "Steamwebhelper";
      workspace = "10 silent";
      suppress_event = "activatefocus";
    }
    {
      name = "steamsignin";
      "match:initial_title" = "Sign in to Steam";
      "match:initial_class" = "steam";
      center = true;
      float = "on";
      suppress_event = "activatefocus";
      workspace = "10 silent";
    }
    {
      name = "steam";
      "match:class" = "steam|Steam";
      workspace = "10 silent";
      suppress_event = "activatefocus";
    }
    {
      name = "steamgames";
      "match:class" = "^steam_app_.*$";
      fullscreen = "on";
      workspace = "11";
    }
    {
      name = "bnet";
      "match:title" = "Battle.net";
      float = "on";
    }
    {
      name = "wow";
      "match:title" = "^World of Warcraft$";
      fullscreen = "on";
      workspace = "11";
    }
    {
      name = "thunderbirdreminder";
      "match:class" = "org.mozilla.Thunderbird";
      "match:title" = "^.*Reminder.*$";
      suppress_event = "activatefocus";
      float = "on";
      pin = "on";
      size = "(monitor_w*0.2) (monitor_h*0.3)";
      move = "(monitor_w-(monitor_w*0.2)-10) (monitor_h-(monitor_h*0.3)-10)";
    }
    {
      name = "kittydropdown";
      "match:class" = "kittyquick";
      float = "on";
      pin = "on";
    }
    {
      name = "pip";
      "match:class" = "firefox";
      "match:title" = "Picture-in-Picture";
      suppress_event = "activatefocus";
      no_initial_focus = "on";
      float = "on";
      pin = "on";
      size = "(monitor_w*0.2) (monitor_h*0.3)";
      move = "(monitor_w-(monitor_w*0.2)-10) (monitor_h-(monitor_h*0.3)-10)";
    }
    {
      name = "sgdbooppopup";
      "match:class" = "SGDBoop";
      float = true;
    }
    {
      name = "hyprpopup";
      "match:class" = "hyprland-dialog";
      pin = true;
    }
    {
      name = "gamescopegames";
      "match:class" = "gamescope";
      workspace = "11";
    }
  ]
  ++ lib.optionals isVoid [
    {
      name = "spotify";
      "match:class" = "spotify";
      workspace = "3 silent";
    }
    {
      name = "thunderbird";
      "match:class" = "org.mozilla.Thunderbird";
      workspace = "4 silent";
    }
    {
      name = "fractal";
      "match:class" = "org.gnome.Fractal";
      workspace = "4 silent";
    }
  ]
  ++ lib.optionals isVoidFrame [
    {
      name = "spotifyframe";
      "match:class" = "spotify";
      workspace = "4 silent";
    }
  ];

  layerrule = [
    {
      name = "noctaliahide";
      "match:namespace" = "^noctalia-notifications.*$";
      no_screen_share = "on";
    }
  ];
}
