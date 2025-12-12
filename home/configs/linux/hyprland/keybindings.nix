{ ... }:
{
  "$mod" = "SUPER";

  bind = [
    # App binds
    "$mod SHIFT, q, exec, hyprshutdown"
    # "$mod SHIFT, q, exec, hyprctl dispatch exit"
    "$mod, Return, exec, kitty"
    "$mod, code:49, exec, kitten quick-access-terminal"
    "$mod, delete, exec, noctalia-shell ipc call sessionMenu toggle"
    "$mod SHIFT, delete, exec, noctalia-shell ipc call lockScreen lock"
    "$mod, q, killactive,"
    "$mod, b, exec, firefox"
    "$mod SHIFT, b, exec, firefox --private-window"
    "$mod, Space, exec, noctalia-shell ipc call launcher toggle"
    "$mod, v, exec, noctalia-shell ipc call launcher clipboard"
    "$mod SHIFT, c, exec, pgrep -x hyprpicker > /dev/null 2>&1 && killall hyprpicker || hyprpicker -a -f hex -r"
    "$mod, e, exec, thunar"

    # Window management
    "$mod SHIFT, Space, togglefloating"
    "$mod SHIFT, Space, centerwindow"
    "$mod, f, fullscreen, 1"
    "$mod SHIFT, f, fullscreen, 0"
    "$mod, c, centerwindow"

    # Screenshot
    ",Print, exec, hyprshot -z -m region --clipboard-only"
    "SHIFT, Print, exec, hyprshot -z --clipboard-only --mode region; sleep 0.5s && wl-paste | swappy -f -"
    "CTRL, Print, exec, hyprshot -z --mode region"

    # Focus movement
    "$mod, h, movefocus, l"
    "$mod, left, movefocus, l"
    "$mod, l, movefocus, r"
    "$mod, k, movefocus, u"
    "$mod, j, movefocus, d"
    "$mod, right, movefocus, r"
    "$mod, up, movefocus, u"
    "$mod, down, movefocus, d"

    # Window movement
    "$mod SHIFT, h, movewindow, l"
    "$mod SHIFT, left, movewindow, l"
    "$mod SHIFT, l, movewindow, r"
    "$mod SHIFT, k, movewindow, u"
    "$mod SHIFT, j, movewindow, d"
    "$mod SHIFT, right, movewindow, r"
    "$mod SHIFT, up, movewindow, u"
    "$mod SHIFT, down, movewindow, d"

    # Alt tab
    "ALT, tab, workspace, previous"

    # Workspace switching
    "$mod, 1, workspace, 1"
    "$mod, 2, workspace, 2"
    "$mod, 3, workspace, 3"
    "$mod, d, workspace, 3"
    "$mod, 4, workspace, 4"
    "$mod, 5, workspace, 5"
    "$mod, 6, workspace, 6"
    "$mod, 7, workspace, 7"
    "$mod, 8, workspace, 8"
    "$mod, 9, workspace, 9"
    "$mod, s, workspace, 10"
    "$mod, g, workspace, 11"

    # Move to workspace
    "$mod SHIFT, 1, movetoworkspace, 1"
    "$mod SHIFT, 2, movetoworkspace, 2"
    "$mod SHIFT, 3, movetoworkspace, 3"
    "$mod SHIFT, d, movetoworkspace, 3"
    "$mod SHIFT, 4, movetoworkspace, 4"
    "$mod SHIFT, 5, movetoworkspace, 5"
    "$mod SHIFT, 6, movetoworkspace, 6"
    "$mod SHIFT, 7, movetoworkspace, 7"
    "$mod SHIFT, 8, movetoworkspace, 8"
    "$mod SHIFT, 9, movetoworkspace, 9"
    "$mod SHIFT, s, movetoworkspace, 10"
    "$mod SHIFT, g, movetoworkspace, 11"

    # Focus workspace on current monitor
    "$mod CTRL SHIFT, 1, focusworkspaceoncurrentmonitor, 1"
    "$mod CTRL SHIFT, 2, focusworkspaceoncurrentmonitor, 2"
    "$mod CTRL SHIFT, 3, focusworkspaceoncurrentmonitor, 3"

    # Mouse wheel workspace switching
    "$mod, mouse_down, workspace, m+1"
    "$mod, mouse_up, workspace, m-1"

    # Resize toggle submap
    "$mod SHIFT, R, submap, resize"
  ];

  binde = [
    "$mod, equal, resizeactive, 10 10%"
    "$mod, minus, resizeactive, -10 -10%"
  ];

  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];

  bindl = [
    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1"
    ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    "Ctrl, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    "Ctrl, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+ -l 1"
    "Ctrl, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-"
    ",XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
    ",XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
    ",XF86AudioPlay, exec, playerctl play-pause"
    ",XF86AudioNext, exec, playerctl next"
    ",XF86AudioPrev, exec, playerctl previous"
  ];
}
