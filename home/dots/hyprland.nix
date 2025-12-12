{ inputs, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;

    settings = {
      # Environment variables
      env = [
        "ENABLE_HDR_WSI,1"
        "DXVK_HDR,1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "QT_QPA_PLATFORMTHEME,gtk3"
        "AMD_VULKAND_ICD,RADV"
        "MESA_SHADER_CACHE_MAX_SIZE,32G"
        "QT_QUICK_CONTROLS_STYLE,org.hyprland.style"
        "GDK_SCALE,1"
        "QT_SCALE_FACTOR,1"
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "CLUTTER_BACKEND,wayland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "EGL_PLATFORM,wayland"
        "HYPRCURSOR_THEME,catppuccin_hyprcursor"
        "HYPRCURSOR_SIZE,24"
      ];

      # Monitor configuration
      monitor = [
        "DP-2,3440x1440@143.92,4880x1440,1.0,bitdepth,10,cm,hdredid,sdrbrightness,1.3,sdrsaturation,0.93,vrr,1"
        "DP-3,3440x1440@143.92,4880x0,1.0,bitdepth,10,cm,hdredid,sdrbrightness,1.3,sdrsaturation,0.93,vrr,1"
        "HDMI-A-1,2560x1440@59.95,3440x727,1.0,transform,1"
        "eDP-1,2880x1920@120,0x0 ,1.0"
        ",preferred,auto,1"
      ];

      # Workspace configuration
      workspace = [
        "1,monitor:DP-2,default:true"
        "5,monitor:DP-2,default:true"
        "10,monitor:DP-2,default:true"
        "11,monitor:DP-2,default:true"
        "2,monitor:DP-3,default:true"
        "4,monitor:DP-3,default:true"
        "3,monitor:HDMI-A-1,default:true,layoutopt:orientation:top"
      ];

      # Input configuration
      input = {
        follow_mouse = 1;
        sensitivity = 0;
        scroll_factor = 1.0;
      };

      # General configuration
      general = {
        gaps_in = 5;
        gaps_out = 8;
        border_size = 3;
        "col.active_border" = "rgb(37f499) rgb(04d1f9) 90deg";
        "col.inactive_border" = "rgb(a48cf2)";
        "col.nogroup_border" = "rgb(a48cf2)";
        "col.nogroup_border_active" = "rgba(36F498FF)";
        resize_on_border = true;
        layout = "master";
        extend_border_grab_area = 3;
        hover_icon_on_border = false;
      };

      # Animations
      animations = {
        enabled = true;
        workspace_wraparound = true;
        bezier = [
          "easeOutCubic,0.65,0,0.35,0.8"
          "easeInOut,0.42,0,0.58,0.8"
          "overshoot,0.05,0.9,0.1,0.8"
        ];
        animation = [
          "windows,1,4,default,popin"
          "layers,0"
          "workspaces,1,3,default,slide"
        ];
      };

      # Dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
        default_split_ratio = 1;
      };

      # Master layout
      master = {
        new_status = "slave";
        new_on_top = false;
        allow_small_split = false;
        mfact = 0.58;
      };

      # Gestures
      # gesture = { workspace_swipe = false; };

      # Decoration
      decoration = {
        rounding = 8;
        dim_inactive = true;
        dim_strength = 5.0e-2;

        blur = {
          enabled = true;
          size = 8;
          passes = 1;
          new_optimizations = true;
          ignore_opacity = true;
          xray = true;
        };

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          ignore_window = true;
          color = "rgb(212337)";
        };
      };

      # Rendering
      render = {
        direct_scanout = 2;
        cm_enabled = true;
        cm_fs_passthrough = 2;
        cm_auto_hdr = 0;
        cm_sdr_eotf = 0;
      };

      # Experimental features
      experimental = { xx_color_management_v4 = true; };

      # Miscellaneous
      misc = {
        disable_hyprland_logo = false;
        animate_manual_resizes = true;
        focus_on_activate = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        session_lock_xray = true;
      };

      # Xwayland
      xwayland = { force_zero_scaling = true; };

      # Debug
      debug = { disable_logs = true; };

      # Ecosystem
      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      # Cursor
      cursor = {
        sync_gsettings_theme = true;
        no_break_fs_vrr = 1;
        enable_hyprcursor = true;
        default_monitor = "DP-2";
      };

      # Keybindings
      "$mod" = "SUPER";

      bind = [
        # App binds
        "$mod SHIFT, q, exec, hyprshutdown"
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

      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];

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

      # Resize submap
      submap = [ "resize" ];

      # Window rules
      windowrule = [
        "workspace 3 silent,class:^(spotify)$"
        "workspace 3 silent,class:^(vesktop)$"
        "workspace 2 silent,title:^(Stream Deck UI)$"
        "workspace 10 silent,class:^(steam|Steam)$"
        "workspace 10 silent,title:^(Steamwebhelper)$"
        "float,initialTitle:^(Sign in to Steam)$"
        "float,class:^(SGDBoop)$"
        "center,initialTitle:^(Sign in to Steam)$"
        "pin,class:^(hyprland-dialog)$"
        "workspace 4 silent,class:^(org.mozilla.Thunderbird)$"
        "suppressevent activatefocus,class:^(CurseForge)$"
        "suppressevent activatefocus,class:^(steam)$"
        "workspace 4 silent,class:^(org.gnome.Fractal)$"
        "workspace 11,class:^(gamescope)$"
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

      # Layer rules
      layerrule = [ "noscreenshare,namespace:^(noctalia-notifications.*)$" ];

      # Startup applications
      exec-once = [
        "gnome-keyring-daemon --start --components=secrets"
        "dbus-update-activation-environment --systemd --all"
        "hyprctl setcursor catppuccin_hyprcursor 28"
        "gsettings set org.gnome.desktop.interface color-scheme prefer-dark"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME"
        "~/.config/hypr/scripts/wait-for-vesktop-and-move.sh"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "udiskie"
        "systemctl --user start hyprpolkitagent"
        "systemctl --user start hypridle"
        "wl-clip-persist --clipboard regular --reconnect-tries 0"
        "wl-paste --watch cliphist store"
        "noctalia-shell"
        "systemctl --user start pipewire wireplumber"
        "sleep 5 && easyeffects --service-mode -w"
        "nm-applet"
        "exec ~/.config/gtk-3.0/gtksettings.sh"
        "exec import-gsettings"
        "exec /usr/bin/streamcontroller -b"
        "[workspace 10 silent] steam"
        "[workspace 3 silent] spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
        "[workspace 3 silent] vesktop"
        "[workspace 2 silent] firefox-developer-edition"
        "protonmail-bridge --no-window"
        "python3 ~/.config/startupscripts/launch_thunderbird.py"
        "[workspace 4 silent] fractal"
        "[workspace 10 silent] curseforge"
      ];
    };

    extraConfig = # hyprlang
      ''
        # Resize submap bindings
        submap=resize
        binde=,right,resizeactive,20 0
        binde=,left,resizeactive,-20 0
        binde=,up,resizeactive,0 -20
        binde=,down,resizeactive,0 20
        binde=,l,resizeactive,20 0
        binde=,h,resizeactive,-20 0
        binde=,k,resizeactive,0 -20
        binde=,j,resizeactive,0 20
        bind=,escape,submap,reset
        submap=reset
      '';
  };

  # Portal package configuration
  xdg.portal = {
    extraPortals = [
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    ];
  };
}
