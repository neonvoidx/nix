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
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "xrandr --output DP-2 --primary"
    "[workspace 3 silent] vesktop"
    "[workspace 2 silent] firefox"
    "[workspace 4 silent] sleep 2 && thunderbird"
  ]
  ++ lib.optionals isVoid [
    "streamcontroller -b"
    "[workspace 3 silent] spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
    "[workspace 10 silent] steam"
    # "[workspace 4 silent] fractal"
  ]
  ++ lib.optionals isVoidFrame [
    "[workspace 4 silent] spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
  ];

  # Resize submap
  submap = [ "resize" ];
}
