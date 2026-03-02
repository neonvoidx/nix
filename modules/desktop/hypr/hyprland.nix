{ den, inputs, ... }:
{
  den.aspects.hyprland = {
    nixos =
      { ... }:
      {
        programs.hyprland.enable = true;
      };

    homeManager =
      {
        pkgs,
        lib,
        config,
        osConfig ? null,
        ...
      }:
      let
        hostname = if osConfig != null then osConfig.networking.hostName or "" else "";
        isVoid = hostname == "void";
        isVoidFrame = hostname == "voidframe";
      in
      {
        wayland.windowManager.hyprland = {
          enable = true;
          package = null;
          portalPackage = null;

          settings = lib.mkMerge [
            # environment.nix
            {
              env = [
                "ENABLE_HDR_WSI,1"
                "DXVK_HDR,1"
                "ELECTRON_OZONE_PLATFORM_HINT,auto"
                "AMD_VULKAND_ICD,RADV"
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
              ];
            }
            # monitors.nix
            {
              monitor = [
                ",preferred,auto,1"
              ]
              ++ lib.optionals isVoid [
                "DP-2,3440x1440@143.92,4880x1440,1.0,bitdepth,10,cm,hdredid,sdrbrightness,1.3,sdrsaturation,0.93,vrr,1"
                "DP-3,3440x1440@143.92,4880x0,1.0,bitdepth,10,cm,hdredid,sdrbrightness,1.3,sdrsaturation,0.93,vrr,1"
                "HDMI-A-1,2560x1440@59.95,3440x727,1.0,transform,1"
              ]
              ++ lib.optionals isVoidFrame [
                "eDP-1,2880x1920@120,0x0,1.33333"
              ];

              workspace =
                lib.optionals isVoid [
                  "3,monitor:HDMI-A-1,default:true,layoutopt:orientation:top"
                  # waiting on dwindle pr https://github.com/hyprwm/Hyprland/pull/11629 for below rule
                  # "3,monitor:HDMI-A-1,default:true,layout:dwindle"
                  "1,monitor:DP-2,default:true"
                  "5,monitor:DP-2,default:true"
                  "10,monitor:DP-2,default:true"
                  "11,monitor:DP-2,default:true"
                  "2,monitor:DP-3,default:true"
                  "4,monitor:DP-3,default:true"
                ]
                ++ lib.optionals isVoid [
                  "1,monitor:DP-2,default:true"
                  "5,monitor:DP-2"
                  "6,monitor:DP-2"
                  "10,monitor:DP-2,name:steam"
                  "11,name:gaming,monitor:DP-2,rounding:false,decorate:false,border:false,shadow:false"
                  "2,monitor:DP-3"
                  "4,monitor:DP-3"
                  "3,monitor:HDMI-A-1"
                ];
            }
            # keybindings.nix
            {
              "$mod" = "SUPER";

              bind = [
                # App binds
                "$mod SHIFT, q, exec, hyprshutdown"
                "$mod, Return, exec, kitty"
                "$mod, code:49, exec, kitten quick-access-terminal"
                "$mod, delete, exec, noctalia-shell ipc call sessionMenu toggle"
                "$mod SHIFT, delete, exec, noctalia-shell ipc call lockScreen lock"
                "$mod, slash, exec, noctalia-shell ipc call keybind-cheatsheet toggle"
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

                # Window movement
                "$mod SHIFT, h, movewindow, l"
                "$mod SHIFT, left, movewindow, l"
                "$mod SHIFT, l, movewindow, r"
                "$mod SHIFT, right, movewindow, r"
                "$mod SHIFT, k, movewindow, u"
                "$mod SHIFT, up, movewindow, u"
                "$mod SHIFT, j, movewindow, d"
                "$mod SHIFT, down, movewindow, d"

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
                "$mod, 0, workspace, 10"
                "$mod, s, workspace, 10"
                "$mod, g, workspace, 11"

                # Move window to workspace
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
                "$mod SHIFT, 0, movetoworkspace, 10"
                "$mod SHIFT, s, movetoworkspace, 10"
                "$mod SHIFT, g, movetoworkspace, 11"

                # Mouse scroll workspace
                "$mod, mouse_down, workspace, e+1"
                "$mod, mouse_up, workspace, e-1"

                # Master layout
                "$mod, m, layoutmsg, swapwithmaster"
                "$mod, i, layoutmsg, addmaster"

                # Resize submap
                "$mod, r, submap, resize"

                # Media keys
                ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                ",XF86AudioPlay, exec, playerctl play-pause"
                ",XF86AudioPrev, exec, playerctl previous"
                ",XF86AudioNext, exec, playerctl next"
                ",XF86MonBrightnessUp, exec, brightnessctl set +5%"
                ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
              ];

              bindm = [
                "$mod, mouse:272, movewindow"
                "$mod, mouse:273, resizewindow"
              ];

              binde = [
                ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              ];
            }
            # windowrules.nix
            {
              windowrule = [
                {
                  name = "godot";
                  "match:title" = ".*(DEBUG).*";
                  "match:initial_class" = "Godot";
                  fullscreen = "off";
                  maximize = "on";
                  workspace = "11";
                  float = "off";
                }
                {
                  name = "godot_game";
                  "match:title" = ".*(DEBUG).*";
                  "match:initial_title" = "Godot";
                  fullscreen = "off";
                  maximize = "off";
                  center = "on";
                  float = "on";
                  workspace = "11";
                }
                {
                  name = "noctalia_settings";
                  "match:class" = "org.quickshell";
                  float = "on";
                  center = "on";
                }
                {
                  name = "gnomekeyringprompt";
                  "match:title" = "Unlock Login Keying";
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
                  name = "lostarksplash";
                  "match:class" = "^steam_app_.*$";
                  "match:initial_title" = "SplashScreen";
                  fullscreen = "off";
                  float = "on";
                  center = "on";
                  workspace = "11";
                }
                {
                  name = "ffxiv";
                  "match:title" = "FINAL FANTASY XIV";
                  float = "off";
                  fullscreen = "on";
                  workspace = "11";
                }
                {
                  name = "bnet";
                  "match:title" = "Battle.net.*";
                  float = "off";
                  fullscreen = "off";
                  workspace = "10";
                }
                {
                  name = "bnetlogin";
                  "match:title" = "Battle.net Login";
                  float = "off";
                  fullscreen = "off";
                  workspace = "10";
                }
                {
                  name = "bnetsettings";
                  "match:title" = "Battle.net Settings";
                  float = "on";
                  fullscreen = "off";
                  workspace = "10";
                }
                {
                  name = "hytale";
                  "match:title" = "Hytale";
                  "match:class" = "HytaleClient";
                  fullscreen = "on";
                  workspace = "11";
                }
                {
                  name = "wow";
                  "match:title" = "World of Warcraft";
                  fullscreen = "on";
                  float = "off";
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
                {
                  name = "xwaylandhelper";
                  "match:xwayland" = "true";
                  "match:title" = "^$";
                  "match:class" = "^$";
                  "match:initial_class" = "^$";
                  "match:initial_title" = "^$";
                  opacity = "0.0";
                  float = "true";
                  no_blur = "on";
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
            }
            # settings.nix
            {
              input = {
                follow_mouse = 1;
                sensitivity = 0;
                scroll_factor = 1.0;
              };

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

              dwindle = {
                pseudotile = true;
                preserve_split = true;
                force_split = 2;
                default_split_ratio = 1;
              };

              master = {
                new_status = "slave";
                new_on_top = false;
                allow_small_split = false;
                mfact = 0.58;
              };

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

              render = {
                direct_scanout = 2;
                cm_enabled = true;
                cm_fs_passthrough = 2;
                cm_auto_hdr = 0;
                cm_sdr_eotf = 0;
              };

              misc = {
                disable_hyprland_logo = false;
                animate_manual_resizes = true;
                focus_on_activate = true;
                mouse_move_enables_dpms = true;
                key_press_enables_dpms = true;
                session_lock_xray = true;
              };

              xwayland = {
                force_zero_scaling = true;
              };

              debug = {
                disable_logs = true;
              };

              ecosystem = {
                no_update_news = true;
                no_donation_nag = true;
              };

              cursor = {
                sync_gsettings_theme = true;
                no_break_fs_vrr = 1;
                enable_hyprcursor = true;
                # TODO https://github.com/hyprwm/Hyprland/discussions/13414 currently rotated monitors have black box for cursor
              }
              // lib.optionalAttrs isVoid { default_monitor = "DP-2"; };
            }
            # startup.nix
            {
              exec-once = [
                "dbus-update-activation-environment --systemd --all"
                "hyprctl setcursor catppuccin-mocha-sapphire-cursors 32"
                "~/.config/hypr/scripts/wait-for-vesktop-and-move.sh"
                "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                "xrandr --output DP-2 --primary"
                "xembedsniproxy"
                "[workspace 2 silent] firefox"
                "[workspace 4 silent] sleep 8 && thunderbird"
              ]
              ++ lib.optionals isVoid [
                "sleep 3 && streamcontroller -b"
                "[workspace 3 silent] spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
                "[workspace 10 silent] steam"
              ]
              ++ lib.optionals isVoidFrame [
                "[workspace 4 silent] spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
              ];

              submap = [ "resize" ];
            }
            # layerrule.nix
            {
              layerrule = [
                {
                  name = "noctaliahide";
                  "match:namespace" = "^noctalia-notifications.*$";
                  no_screen_share = "on";
                }
              ];
            }
          ];

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

        xdg.portal = {
          extraPortals = [
            inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
          ];
          config = {
            hyprland = {
              default = [
                "hyprland"
                "gtk"
              ];
              "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            };
          };
        };

        home.file.".config/hypr/xdph.conf".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/hypr/xdph.conf";
        home.file.".config/hypr/scripts".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/hypr/scripts";
        home.file.".config/hypr/hyprland/monitors".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/hypr/hyprland/monitors";
      };
  };
}
