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
  # Startup applications
  exec-once = [
    "dbus-update-activation-environment --systemd --all"
    "hyprctl setcursor catppuccin-mocha-sapphire-cursors 24"
    "~/.config/hypr/scripts/wait-for-vesktop-and-move.sh"
    # TODO hyprland starts as systemd now I believe with home manager, so some of these we should be able to automate outside
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "noctalia-shell -d"
    "nm-applet"
    "[workspace 3 silent] vesktop"
    "[workspace 2 silent] firefox"
  ]
  ++ lib.optionals isVoid [
    "exec streamcontroller -b"
    "[workspace 3 silent] spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
    "[workspace 10 silent] steam"
    "python3 ~/.config/startupscripts/launch_thunderbird.py"
    "[workspace 4 silent] fractal"
  ]
  ++ lib.optionals isVoidFrame [
    "[workspace 4 silent] spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
  ];

  # Resize submap
  submap = [ "resize" ];
}
