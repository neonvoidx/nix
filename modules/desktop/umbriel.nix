{ den, inputs, ... }:
{
  den.aspects.umbriel =
    { host, ... }:
    {
      nixos =
        { pkgs, ... }:
        {
          imports = [ inputs.umbriel.nixosModules.default ];
          programs.umbriel.enable = true;
          environment.systemPackages = [ pkgs.xwayland-satellite ];
        };

      homeManager =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        let
          isMultiMonitor = host.isMultiMonitor or false;

          monitors = host.monitors or { };
          mainMon = monitors.main or { };
          secondaryMon = monitors.secondary or { };
          portraitMon = monitors.portrait or { };
          builtinMon = monitors.builtin or { };

          mainName = mainMon.name or "";
          secondaryName = secondaryMon.name or "";
          portraitName = portraitMon.name or "";
          builtinName = builtinMon.name or "";
          primaryName =
            if mainMon.primary or false then
              mainName
            else if builtinMon.primary or false then
              builtinName
            else
              "";
          # Games open on workspace 2 of the gaming desktop's primary output.
          # voidframe is not a gaming host, so no game workspace is reserved on
          # its built-in panel.
          gameOutput = if (host.isGaming or false) then primaryName else "";
          gamePlacement = lib.optionalAttrs (gameOutput != "") {
            default_output = gameOutput;
            default_workspace = 2;
          };

          # Games draw their own frame: no blur, shadow, or effects.
          noCompositorChrome = {
            blur = false;
            shadow = false;
            border_effect = "off";
            window_effect = "off";
          };

          mkPosition = pos: map builtins.fromJSON (lib.splitString "x" pos);

          transformToString =
            t:
            {
              "0" = "normal";
              "1" = "90";
              "2" = "180";
              "3" = "270";
              "4" = "flipped";
              "5" = "flipped_90";
              "6" = "flipped_180";
              "7" = "flipped_270";
            }
            .${toString t} or "normal";

          mkOutput =
            mon:
            let
              # The scrolling strip is perpendicular to workspace_axis: use a
              # horizontal workspace axis for a rotated (portrait) output so
              # its lanes run top-to-bottom; landscape strips run left-to-right.
              axis =
                if ((mon.transform or 0) != 0 && (mon.transform or 0) != 2) then "horizontal" else "vertical";
            in
            {
              enabled = true;
              scale = mon.scale or 1.0;
              vrr = if (mon.vrr or 0) == 1 then "always" else "disabled";
              workspace_axis = axis;
              inherit (mon) mode;
              position = mkPosition mon.position;
            }
            // lib.optionalAttrs (mon ? transform) {
              transform = transformToString mon.transform;
            }
            // lib.optionalAttrs (mon.supports_hdr or false) {
              hdr = "on";
              sdr_white = builtins.floor ((mon.sdrbrightness or 0.5) * (mon.sdr_max_luminance or 400));
            };

          # Gaming monitors (main/secondary ultrawides): allow tearing and
          # direct scanout for lower input lag.
          mkGamingOutput =
            mon:
            (mkOutput mon)
            // {
              tearing = true;
              direct_scanout = true;
            };

          # Every output uses Umbriel's dynamic workspace inventory.  The
          # portrait output has the horizontal workspace axis required for a
          # vertical scrolling strip (Discord above Spotify).
          output =
            { }
            // lib.optionalAttrs (mainName != "" && isMultiMonitor) {
              "${mainName}" = (mkGamingOutput mainMon) // {
                enabled = true;
                # Workspace 2 is the game workspace.
                min_workspaces = 2;
              };
            }
            // lib.optionalAttrs (secondaryName != "" && isMultiMonitor) {
              "${secondaryName}" = (mkGamingOutput secondaryMon) // {
                enabled = true;
                min_workspaces = 2;
              };
            }
            // lib.optionalAttrs (portraitName != "") {
              "${portraitName}" = (mkOutput portraitMon) // {
                enabled = true;
                min_workspaces = 1;
                workspace_axis = "horizontal";
              };
            }
            // lib.optionalAttrs (builtinName != "") {
              # Laptop built-in panel (voidframe): single non-gaming output.
              "${builtinName}" = (mkOutput builtinMon) // {
                enabled = true;
                # Non-gaming host: one dynamic workspace is enough.
                min_workspaces = 1;
              };
            };

        in
        {
          imports = [ inputs.umbriel.homeModules.default ];

          programs.umbriel = {
            enable = true;

            settings = {
              include.files = [
                "shaders/border/accent-pulse/effect.toml"
                "shaders/animation/wobbly-lifecycle/effect.toml"
                "shaders/animation/wobbly-move/effect.toml"
                # Reveal ships with umbriel; no local copy needed.
                "${config.programs.umbriel.package}/share/umbriel/effects/animation/reveal/effect.toml"
              ];

              effects.border = "accent-pulse";

              general = {
                autostart = [
                  "~/.local/bin/tmux-refresh-desktop-environment umbriel"
                  "noctalia"
                  "firefox"
                  "bash -c 'sleep 8 && thunderbird'"
                  # "spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
                  # Stupid, but pear doesnt start open, so calling it twice will open
                  "pear-desktop"
                  "steam"
                ]
                ++ lib.optionals (portraitName != "") [
                  "UMBRIEL_PORTRAIT_OUT=${portraitName} ~/.config/umbriel/scripts/wait-for-discord-and-move.sh"
                ];
                mod_key = "Super";
                xwayland = true;
                focus_on_activate = true;
                show_cheatsheet = false;
              };

              environment = {
                ENABLE_HDR_WSI = "1";
                DXVK_HDR = "1";
                ELECTRON_OZONE_PLATFORM_HINT = "auto";
                AMD_VULKAN_ICD = "RADV";
                GDK_SCALE = "1";
                QT_SCALE_FACTOR = "1";
                GDK_BACKEND = "wayland,x11,*";
                QT_QPA_PLATFORM = "wayland;xcb";
                CLUTTER_BACKEND = "wayland";
                QT_AUTO_SCREEN_SCALE_FACTOR = "1";
                QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
                MOZ_ENABLE_WAYLAND = "1";
                EGL_PLATFORM = "wayland";
              }
              // lib.optionalAttrs (primaryName != "") {
                UMBRIEL_PRIMARY_OUT = primaryName;
              }
              // lib.optionalAttrs (isMultiMonitor && secondaryName != "") {
                UMBRIEL_SECONDARY_OUT = secondaryName;
              };

              inherit output;

              # Keep the portrait Discord/Pear lanes flush to the output while
              # every other workspace centers its focused scrolling column.
              workspace = lib.optionals (portraitName != "") [
                {
                  output = portraitName;
                  index = 1;
                  layout.scrolling = {
                    center_focused = "never";
                    center_underfull_strip = false;
                  };
                }
              ];

              colors = {
                shadow = "#212337FF";
                accent_primary = "#37F499FF";
                accent_secondary = "#A48CF2FF";
                warning = "#F7C67FFF";
                error = "#F16C75FF";
                border = {
                  focused = "#37F499FF";
                  unfocused = "#A48CF2FF";
                };
              };

              appearance = {
                prefer_no_csd = true;
                border_width = 3;
                corner_radius = 8;
                blur = {
                  enabled = true;
                  optimized = true;
                  passes = 1;
                  radius = 8;
                };
                shadow = {
                  enabled = true;
                  softness = 8;
                };
              };

              input = {
                cursor = {
                  theme = "eldritch-great-old-green-cursors";
                  size = 32;
                  hardware_cursor = true;
                  follows_focus = true;
                };
                focus = {
                  follows_mouse = true;
                  # follows_mouse_max_scroll = 0.0;
                };
                keyboard = {
                  repeat_rate = 25;
                  repeat_delay = 600;
                };
              };

              layout = {
                mode = "scrolling";
                gap = 8;
                extent_presets = [
                  0.5
                  0.75
                  0.9
                  1.0
                ];
                scrolling = {
                  default_extent_fraction = 0.9;
                  # Keep short strips flush by default; portrait workspace 1
                  # overrides focus centering above for its Discord/Pear lanes.
                  center_underfull_strip = false;
                  center_focused = "on_overflow";
                };
              };

              animation = {
                enabled = true;
                duration_ms = 150;
                beziers = {
                  smoothMove = [
                    0.1
                    0.9
                    0.2
                    1.0
                  ];
                  smoothFade = [
                    0.05
                    0.8
                    0.1
                    1.0
                  ];
                };
                windows_in = {
                  enabled = true;
                  effect = "wobbly-lifecycle";
                  duration_ms = 150;
                  curve = "smoothFade";
                };
                windows_out = {
                  enabled = true;
                  effect = "wobbly-lifecycle";
                  duration_ms = 150;
                  curve = "smoothFade";
                };
                windows_move = {
                  enabled = true;
                  effect = "wobbly-move";
                  duration_ms = 150;
                  curve = "smoothMove";
                };
                windows_drag.physics = true;
                workspaces = {
                  enabled = true;
                  effect = "reveal";
                  duration_ms = 150;
                  curve = "smoothMove";
                };
                overview = {
                  enabled = true;
                  effect = "reveal";
                  duration_ms = 150;
                  curve = "smoothFade";
                };
                scratchpad = {
                  enabled = true;
                  effect = "reveal";
                  duration_ms = 150;
                  curve = "smoothFade";
                  dim = 0.8;
                  blur = true;
                  scale = 0.0;
                };
                border = {
                  enabled = true;
                  duration_ms = 250;
                  curve = "smoothFade";
                };
                dim_unfocused = {
                  enabled = false;
                  duration_ms = 150;
                  curve = "smoothFade";
                  dim = 0.0;
                };
                layers = {
                  enabled = true;
                  effect = "reveal";
                  duration_ms = 150;
                  curve = "smoothFade";
                };
              };

              overview.zoom = 0.5;

              # Thunderbird and Steam autostart and stay hidden here until
              # their toggle is pressed. `spawn_when_empty` relaunches the
              # application if it is ever closed.
              scratchpad = [
                { name = "streamcontroller"; }
                {
                  name = "thunderbird";
                  spawn_when_empty = "thunderbird";
                }
                {
                  name = "steam";
                  spawn_when_empty = "steam";
                }
              ];

              keybinds = {
                # Session
                "Mod+Shift+Q" = {
                  action = "session-quit:skip-confirmation";
                  repeat = false;
                };

                # Applications
                "Mod+Return" = {
                  action = "spawn:kitty";
                  repeat = false;
                };
                "Mod+Delete" = {
                  action = "spawn:noctalia msg panel-toggle session";
                  repeat = false;
                };
                "Mod+Shift+Delete" = {
                  action = "spawn:noctalia msg session lock";
                  repeat = false;
                };
                "Mod+Space" = {
                  action = "spawn:noctalia msg panel-toggle launcher";
                  repeat = false;
                };
                "Mod+V" = {
                  action = "spawn:noctalia msg panel-toggle clipboard";
                  repeat = false;
                };
                "Mod+Bracketright" = {
                  action = "spawn:noctalia msg wallpaper-random";
                  repeat = false;
                };
                "Mod+B" = {
                  action = "spawn:firefox";
                  repeat = false;
                };
                "Mod+Shift+B" = {
                  action = "spawn:firefox --private-window";
                  repeat = false;
                };
                "Mod+E" = {
                  action = "spawn:thunar";
                  repeat = false;
                };
                "Mod+O" = {
                  action = "spawn:obsidian";
                  repeat = false;
                };
                "Mod+Page_Up" = {
                  action = "spawn:noctalia msg notification-dnd-toggle";
                  repeat = false;
                };

                # Focus a running application (lookup via Umbriel IPC)
                "Mod+D" = {
                  action = "spawn:~/.config/umbriel/scripts/focus-app.sh app discord '^Discord Popout$'";
                  repeat = false;
                };
                # Steam and Thunderbird live in named scratchpads
                "Mod+S" = {
                  action = "scratchpad-toggle:steam";
                  repeat = false;
                };
                "Mod+T" = {
                  action = "scratchpad-toggle:thunderbird";
                  repeat = false;
                };
                "Mod+G" = {
                  action = "spawn:~/.config/umbriel/scripts/focus-app.sh game";
                  repeat = false;
                };

                # Windows
                "Mod+Q" = {
                  action = "window-close";
                  repeat = false;
                };
                "Mod+Shift+Space" = {
                  action = "window-toggle-floating";
                  repeat = false;
                };
                "Mod+F" = {
                  action = "window-modify-primary-extent:0.9";
                  repeat = false;
                };
                "Mod+Shift+F" = {
                  action = "window-toggle-fullscreen";
                  repeat = false;
                };
                # Center column
                "Mod+C" = {
                  action = "column-center";
                  repeat = false;
                };
                # Cycle focus across outputs instead of windows
                "Alt+Tab" = {
                  action = "output-focus-next";
                  repeat = false;
                };
                "Shift+Alt+Tab" = {
                  action = "output-focus-previous";
                  repeat = false;
                };

                # FOCUS
                #
                # Directional focus stays local to the scrolling layout, then
                # crosses to the adjacent output at a strip edge.
                "Mod+H" = "window-focus-or-output-left";
                "Mod+L" = "window-focus-or-output-right";
                "Mod+K" = "window-focus-or-output-up";
                "Mod+J" = "window-focus-or-output-down";
                # Output focus
                "Mod+Left" = "output-focus-left";
                "Mod+Right" = "output-focus-right";
                "Mod+Down" = "output-focus-down";
                "Mod+Up" = "output-focus-up";
                "Mod+Alt+H" = "output-focus-left";
                "Mod+Alt+L" = "output-focus-right";
                "Mod+Alt+J" = "output-focus-down";
                "Mod+Alt+K" = "output-focus-up";
                # First column in workspace
                "Mod+Backspace" = "column-focus-first";
                # Last column in workspace
                "Mod+A" = "column-focus-last";

                # MOVEMENT
                #
                # Move a window in the indicated screen direction, crossing
                # outputs when the current strip has no neighbor.
                "Mod+Shift+H" = "window-move-or-output-left";
                "Mod+Shift+L" = "window-move-or-output-right";
                "Mod+Shift+K" = "window-move-or-output-up";
                "Mod+Shift+J" = "window-move-or-output-down";
                # Explicitly move current window to output direction
                "Mod+Shift+Left" = "window-move-to-output-left";
                "Mod+Shift+Right" = "window-move-to-output-right";
                "Mod+Shift+Up" = "window-move-to-output-up";
                "Mod+Shift+Down" = "window-move-to-output-down";
                # Move to first in workspace
                "Mod+Shift+A" = "column-move-to-last";
                # Move to last in workspace
                "Mod+Shift+Backspace" = "column-move-to-first";

                # Pin
                "Mod+P" = "window-toggle-pinned";

                # Layout
                "Mod+R" = {
                  action = "window-cycle-primary-extent";
                  repeat = false;
                };
                "Mod+Equal" = {
                  action = "window-modify-primary-extent:0.05";
                  repeat = true;
                };
                "Mod+Minus" = {
                  action = "window-modify-primary-extent:-0.05";
                  repeat = true;
                };

                # Workspaces: bare digits select a position on the output
                # under the pointer.
                "Mod+1" = {
                  action = "workspace-switch:1";
                  repeat = false;
                };
                "Mod+2" = {
                  action = "workspace-switch:2";
                  repeat = false;
                };
                "Mod+3" = {
                  action = "workspace-switch:3";
                  repeat = false;
                };
                "Mod+4" = {
                  action = "workspace-switch:4";
                  repeat = false;
                };
                "Mod+5" = {
                  action = "workspace-switch:5";
                  repeat = false;
                };
                "Mod+6" = {
                  action = "workspace-switch:6";
                  repeat = false;
                };
                "Mod+7" = {
                  action = "workspace-switch:7";
                  repeat = false;
                };
                "Mod+8" = {
                  action = "workspace-switch:8";
                  repeat = false;
                };
                "Mod+9" = {
                  action = "workspace-switch:9";
                  repeat = false;
                };
                "Mod+0" = {
                  action = "workspace-switch:10";
                  repeat = false;
                };
                "Mod+Shift+1" = {
                  action = "window-move-to-workspace:1";
                  repeat = false;
                };
                "Mod+Shift+2" = {
                  action = "window-move-to-workspace:2";
                  repeat = false;
                };
                "Mod+Shift+3" = {
                  action = "window-move-to-workspace:3";
                  repeat = false;
                };
                "Mod+Shift+4" = {
                  action = "window-move-to-workspace:4";
                  repeat = false;
                };
                "Mod+Shift+5" = {
                  action = "window-move-to-workspace:5";
                  repeat = false;
                };
                "Mod+Shift+6" = {
                  action = "window-move-to-workspace:6";
                  repeat = false;
                };
                "Mod+Shift+7" = {
                  action = "window-move-to-workspace:7";
                  repeat = false;
                };
                "Mod+Shift+8" = {
                  action = "window-move-to-workspace:8";
                  repeat = false;
                };
                "Mod+Shift+9" = {
                  action = "window-move-to-workspace:9";
                  repeat = false;
                };
                "Mod+Shift+0" = {
                  action = "window-move-to-workspace:10";
                  repeat = false;
                };

                # Relative workspace navigation
                "Mod+Home" = {
                  action = "workspace-previous";
                  repeat = true;
                };
                "Mod+End" = {
                  action = "workspace-next";
                  repeat = true;
                };
                "Mod+Shift+Home" = {
                  action = "window-move-to-workspace-previous";
                  repeat = true;
                };
                "Mod+Shift+End" = {
                  action = "window-move-to-workspace-next";
                  repeat = true;
                };
                "Mod+Grave" = {
                  action = "workspace-focus-last";
                  repeat = false;
                };

                # Mouse wheel for workspace navigation
                "Mod+WheelUp" = {
                  action = "workspace-previous";
                  repeat = false;
                  cooldown_ms = 150;
                };
                "Mod+WheelDown" = {
                  action = "workspace-next";
                  repeat = false;
                  cooldown_ms = 150;
                };
                "Mod+Tab" = {
                  action = "overview-toggle";
                  repeat = false;
                };
                "Mod+slash" = {
                  action = "cheatsheet-toggle";
                  repeat = false;
                };

                # Media and screenshots
                "Print" = {
                  action = "spawn:noctalia msg screenshot-region";
                  repeat = false;
                };
                "Shift+Print" = {
                  action = "spawn:noctalia msg screenshot-annotate";
                  repeat = false;
                };
                "Ctrl+Print" = {
                  action = "spawn:noctalia msg screenshot-fullscreen all";
                  repeat = false;
                };
                "XF86AudioRaiseVolume" = "spawn:wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
                "XF86AudioLowerVolume" = "spawn:wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
                "XF86AudioMute" = {
                  action = "spawn:wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                  repeat = false;
                };
                "Ctrl+XF86AudioRaiseVolume" = "spawn:wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
                "Ctrl+XF86AudioLowerVolume" = "spawn:wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
                "Ctrl+XF86AudioMute" = {
                  action = "spawn:wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
                  repeat = false;
                };
                "XF86AudioPlay" = {
                  action = "spawn:playerctl play-pause";
                  repeat = false;
                };
                "XF86AudioPrev" = {
                  action = "spawn:playerctl previous";
                  repeat = false;
                };
                "XF86AudioNext" = {
                  action = "spawn:playerctl next";
                  repeat = false;
                };
                "XF86MonBrightnessUp" = "spawn:brightnessctl set +5%";
                "XF86MonBrightnessDown" = "spawn:brightnessctl set 5%-";

              };

              window_rule = [
                # Global blur — keep first so later rules can override it
                {
                  blur = true;
                  blur_optimized = true;
                }

                # Proton-tagged games (Steam's Wayland client) that no
                # explicit rule below covers still get bare frames.
                (
                  {
                    match.xdg_tag = "^proton-game$";
                  }
                  // noCompositorChrome
                )

                # Games tagged by the client open on workspace 2. If the
                # primary output is disabled, Umbriel uses an enabled output.
                ({ match.content_type = "game"; } // noCompositorChrome // gamePlacement)

                # Noctalia settings
                {
                  match = {
                    app_id = "^dev.noctalia.Noctalia$";
                    title = "Noctalia Settings";
                  };
                  default_floating = true;
                  default_position = {
                    x = 0;
                    y = 0;
                  };
                  default_floating_size_px = {
                    width = 1020;
                    height = 900;
                  };
                }

                # Noctalia share picker
                {
                  match.app_id = "^dev.noctalia.UmbrielSharePicker$";
                  default_floating = true;
                  default_floating_size_px = {
                    width = 800;
                    height = 600;
                  };
                }

                # Blender file browser
                {
                  match = {
                    app_id = "^blender$";
                    title = "File Browser";
                  };
                  default_floating = true;
                  default_position = {
                    x = 0;
                    y = 0;
                  };
                  default_floating_size = {
                    width = 0.6;
                    height = 0.6;
                  };
                }

                # xdg portal screen share picker
                {
                  match.title = "Select what to share";
                  default_floating = true;
                  default_position = {
                    x = 0;
                    y = 0;
                  };
                  default_floating_size = {
                    width = 0.8;
                    height = 0.8;
                  };
                }

                # xdg portal file picker
                {
                  match.app_id = "^xdg-desktop-portal.*$";
                  default_floating = true;
                  default_position = {
                    x = 0;
                    y = 0;
                  };
                  default_floating_size = {
                    width = 0.6;
                    height = 0.6;
                  };
                }

                # GNOME keyring unlock prompt
                {
                  match.title = "Unlock Login Keying";
                  default_floating = true;
                  default_pinned = true;
                }

                # Firefox starts on workspace 1 of the secondary output.
                (
                  {
                    match = {
                      app_id = "^firefox$";
                      at_startup = true;
                    };
                    default_focused = false;
                  }
                  // lib.optionalAttrs (isMultiMonitor && secondaryName != "") {
                    default_output = secondaryName;
                    default_workspace = 1;
                  }
                )

                # The Thunderbird main window is the only window in the scratchpad,
                # so Mod+T reveals just the inbox. Its title always ends in
                # "- Mozilla Thunderbird"; compose windows end in
                # "- Thunderbird" instead.
                #
                # No default_floating_size: Thunderbird ignores compositor size
                # configures on native Wayland, so it keeps whatever size it
                # picks for itself (1440x1379) regardless of the request. Steam
                # honors the request, so its rule below does set a size. Centering
                # still works, so we place the window and let Gecko own the extent.
                {
                  match = {
                    app_id = "^thunderbird$";
                    title = ".* - Mozilla Thunderbird$";
                  };
                  default_scratchpad = "thunderbird";
                  default_focused = false;
                  focus_on_activate = false;
                  default_position = {
                    x = 0;
                    y = 0;
                    anchor = "center";
                  };
                }

                # Compose windows pin above the inbox. default_pinned also opts
                # a window out of scratchpad inheritance, so they stay out of the
                # scratchpad entirely and the inbox can never cover them.
                # Reminders are excluded; they have their own pinned rule below.
                {
                  match = {
                    app_id = "^thunderbird$";
                    title = "^(?!.*Reminder).+$";
                  };
                  default_floating = true;
                  default_pinned = true;
                  default_position = {
                    x = 0;
                    y = 0;
                    anchor = "center";
                  };
                }

                # Discord main window
                (
                  {
                    match = {
                      app_id = "^discord$";
                      title = "^(?!Discord Popout$).*";
                    };
                    default_focused = false;
                  }
                  // lib.optionalAttrs (portraitName != "") {
                    default_output = portraitName;
                    default_workspace = 1;
                    default_scrolling_column = "discord";
                    default_scrolling_column_order = 1;
                    default_scrolling_extent = 0.75;
                  }
                )

                # Discord popout
                (
                  {
                    match = {
                      app_id = "^discord$";
                      title = "Discord Popout";
                    };
                    # Streams/popout windows stay on the secondary output.
                    default_focused = false;
                  }
                  // lib.optionalAttrs (secondaryName != "") {
                    default_output = secondaryName;
                  }
                )

                # StreamController
                {
                  match.app_id = "^com.core447.StreamController$";
                  default_scratchpad = "streamcontroller";
                }

                # Spotify rule commented out; using Pear instead
                # (
                #   {
                #     match.app_id = "^spotify$";
                #     default_focused = false;
                #   }
                #   // lib.optionalAttrs (portraitName != "") {
                #     default_output = portraitName;
                #     default_workspace = 1;
                #     default_scrolling_column = "spotify";
                #     default_scrolling_column_order = 2;
                #     default_scrolling_extent = 0.25;
                #   }
                # )
                # Pear
                (
                  {
                    match.app_id = "^com.github.th-ch.youtube-music$";
                    default_focused = false;
                  }
                  // lib.optionalAttrs (portraitName != "") {
                    default_output = portraitName;
                    default_workspace = 1;
                    default_scrolling_column = "pear";
                    default_scrolling_column_order = 2;
                    default_scrolling_extent = 0.25;
                  }
                )
              ]
              ++ lib.optionals isMultiMonitor [
                # Fractal
                {
                  match.app_id = "^org.gnome.Fractal$";
                  default_focused = false;
                }
              ]
              ++ [
                # Godot editor
                {
                  match.app_id = "^Godot$";
                  default_floating = true;
                }

                # Godot game (debug runs)
                (
                  {
                    match.title = ".*(DEBUG).*";
                    default_fullscreen = true;
                  }
                  // noCompositorChrome
                  // gamePlacement
                )

                # Steam notification toasts: pinned outside the scratchpad so
                # a toast is readable without revealing the whole client.
                {
                  match = {
                    app_id = "^steam$";
                    title = "^notificationtoasts";
                  };
                  default_floating = true;
                  default_pinned = true;
                  default_focused = false;
                  default_position = {
                    x = 0;
                    y = 0;
                    anchor = "bottom_right";
                  };
                }

                # Steam's main client window is the only window in the scratchpad, so
                # Mod+S reveals just the client, filling the output.
                {
                  match = {
                    app_id = "^steam$";
                    title = "^Steam$";
                  };
                  default_scratchpad = "steam";
                  default_focused = false;
                  default_floating = true;
                  default_floating_size = {
                    width = 0.9;
                    height = 0.9;
                  };
                  default_position = {
                    x = 0;
                    y = 0;
                    anchor = "center";
                  };
                }

                # Child client windows (friends list, per-game settings, game
                # pages, sign-in) pin above the client. default_pinned also opts
                # a window out of scratchpad inheritance, so they stay out of
                # the scratchpad and the client can never cover them.
                {
                  match = {
                    app_id = "^steam$";
                    title = "^(?!Steam$|^notificationtoasts).+$";
                  };
                  default_floating = true;
                  default_pinned = true;
                  default_position = {
                    x = 0;
                    y = 0;
                    anchor = "center";
                  };
                }

                # Steam games
                (
                  {
                    # Many XWayland/Steam windows start with an empty title and set it shortly after mapping.
                    # Require a non-empty title so a later title match can apply a more specific rule (e.g. Battle.net).
                    # SplashScreen is part of the Steam client, not a game.
                    match = {
                      app_id = "^steam_app_.*";
                      title = "^(?!SplashScreen$).+";
                    };
                    default_fullscreen = true;
                  }
                  // noCompositorChrome
                  // gamePlacement
                )

                # Battle.net launched from Steam should remain windowed.
                {
                  match = {
                    app_id = "^steam_app_.*$";
                    title = "^Battle\\.net.*";
                  };
                  default_fullscreen = false;
                  default_focused = true;
                  default_floating = false;
                }
                # Battle.net wayland enabled
                {
                  match = {
                    app_id = "^battle.net.exe.*$";
                    title = "^Battle\\.net.*";
                  };
                  default_fullscreen = false;
                  default_floating = false;
                  default_focused = true;
                }
                # FFXIV
                (
                  {
                    match.title = "FINAL FANTASY XIV";
                    default_fullscreen = true;
                  }
                  // noCompositorChrome
                  // gamePlacement
                )

                # Gamescope
                (
                  {
                    match.app_id = "^gamescope$";
                    default_fullscreen = true;
                  }
                  // noCompositorChrome
                  // gamePlacement
                )

                # World of Warcraft (wine)
                (
                  {
                    match.app_id = "^wow.exe$";
                    default_fullscreen = true;
                  }
                  // noCompositorChrome
                  // gamePlacement
                )

                # World of Warcraft (xwayland)
                (
                  {
                    match.title = "World of Warcraft";
                    default_fullscreen = true;
                  }
                  // noCompositorChrome
                  // gamePlacement
                )

                # Hytale
                (
                  {
                    match.title = "Hytale";
                    default_fullscreen = true;
                  }
                  // noCompositorChrome
                  // gamePlacement
                )

                # Battle.net gifts
                {
                  match = {
                    app_id = "^steam_app_0$";
                    title = "Gifts";
                  };
                  default_floating = true;
                  default_fullscreen = false;
                  default_focused = false;
                }

                # Battle.net whispers
                {
                  match.title = "Battle.net.*Chats and Groups";
                  default_floating = true;
                  default_fullscreen = false;
                  default_focused = false;
                }
                #Bnet avatar
                {
                  match.title = "Select an Avatar";
                  match.app_id = "^steam_app_.*$";
                  default_floating = true;
                  default_fullscreen = false;
                  default_focused = false;
                }

                # Battle.net tray icon
                {
                  match.app_id = "^explorer.exe$";
                  default_floating = true;
                  default_floating_size_px = {
                    width = 25;
                    height = 25;
                  };
                  default_position = {
                    x = 10;
                    y = 10;
                    anchor = "bottom_right";
                  };
                  default_focused = false;
                }

                # Battle.net
                {
                  match = {
                    app_id = "^battle[.]net[.]exe$";
                    title = "^Battle\\.net.*";
                  };
                  default_fullscreen = false;
                  default_focused = false;
                  default_floating = false;
                }

                # Battle.net settings
                {
                  match = {
                    app_id = "^(steam_app_.*|battle[.]net[.]exe)$";
                    title = "Battle.net Settings";
                  };
                  default_pinned = true;
                  default_fullscreen = false;
                  default_focused = false;
                }

                # Thunderbird reminders
                {
                  match = {
                    app_id = "^thunderbird$";
                    title = "^.*Reminder.*$";
                  };
                  default_floating = true;
                  default_pinned = true;
                  default_floating_size = {
                    width = 0.2;
                    height = 0.3;
                  };
                  default_position = {
                    x = 10;
                    y = 10;
                    anchor = "bottom_right";
                  };
                }

                # Kitty quick dropdown
                {
                  match.app_id = "^kittyquick$";
                  default_floating = true;
                  default_pinned = true;
                }

                # Picture-in-picture
                {
                  match.title = "^(Picture-in-Picture|Picture in picture)$";
                  match.app_id = "^firefox$";
                  default_floating = true;
                  default_pinned = true;
                  default_maximize = false;
                  default_position = {
                    x = 20;
                    y = 20;
                    anchor = "bottom_right";
                  };
                  default_focused = false;
                }

                # SteamGridDB
                {
                  match.app_id = "^SGDBoop$";
                  default_floating = true;
                  default_position = {
                    x = 0;
                    y = 0;
                  };
                  default_floating_size = {
                    width = 0.8;
                    height = 0.8;
                  };
                }
              ];

              layer_rule = [
                {
                  match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
                  blur = true;
                  blur_ignore_alpha = 0.5;
                  blur_popups = true;
                  blur_optimized = false;
                }
              ];
            };
          };

          # --------------------------------------------------------------------------
          # Resume hook — restart the umbriel portal after suspend so screen
          # sharing still works (portals can drop their D-Bus / PipeWire
          # connections while the user slice is frozen during sleep).
          # --------------------------------------------------------------------------

          systemd.user.services."restart-umbriel-portal-after-resume" = {
            Unit = {
              Description = "Restart xdg-desktop-portal-umbriel after resume";
              After = [ "graphical-session.target" ];
            };
            Service = {
              Type = "oneshot";
              ExecStart = "${pkgs.bash}/bin/bash -c 'sleep 2 && systemctl --user restart xdg-desktop-portal-umbriel.service'";
              RemainAfterExit = true;
            };
            Install = {
              WantedBy = [
                "graphical-session.target"
                "sleep.target"
              ];
            };
          };

          # The portrait listener is the only runtime helper: workspace and
          # output placement otherwise come directly from dynamic Umbriel
          # configuration.
          home.file.".config/umbriel/scripts".source =
            config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/umbriel/scripts";
          home.file.".config/umbriel/shaders".source =
            config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/umbriel/shaders";
        };
    };
}
