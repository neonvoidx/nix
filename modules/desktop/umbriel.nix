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
          portraitWorkspace = if portraitName != "" then "1/${portraitName}" else "1";

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
              # Scrolling runs perpendicular to the workspace axis.
              axis =
                if (mon.isRotated or false) || (mon.name or "") == "HDMI-A-1" then "horizontal" else "vertical";
            in
            {
              enabled = true;
              scale = mon.scale or 1.0;
              vrr = if (mon.vrr or 0) == 1 then "always" else "disabled";
              workspace_axis = axis;
            }
            // lib.optionalAttrs (mon.mode or "" != "") {
              inherit (mon) mode;
            }
            // lib.optionalAttrs (mon.position or "" != "") {
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

          tomlFormat = pkgs.formats.toml { };

          # ------------------------------------------------------------------
          # Work-mode layout
          # ------------------------------------------------------------------
          # Toggling work mode swaps the live config file and reloads it.
          # In work mode the ultrawide main monitor is switched off
          # (enabled = false), everything lands on the secondary monitor, and
          # the portrait keeps workspace "1".
          workOutput =
            { }
            // lib.optionalAttrs (mainName != "" && isMultiMonitor) {
              "${mainName}" = (mkGamingOutput mainMon) // {
                enabled = false;
              };
            }
            // lib.optionalAttrs (secondaryName != "" && isMultiMonitor) {
              "${secondaryName}" = (mkGamingOutput secondaryMon) // {
                workspaces = "dynamic";
              };
            }
            // lib.optionalAttrs (portraitName != "" && isMultiMonitor) {
              "${portraitName}" = (mkOutput portraitMon) // {
                workspaces = "dynamic";
              };
            }
            // lib.optionalAttrs (builtinName != "" && !isMultiMonitor) {
              "${builtinName}" = (mkOutput builtinMon) // {
                workspaces = "dynamic";
              };
            };

          # Re-home targets for the work toggle, written as shell for
          # toggle-work-mode.sh.
          layoutEnv = lib.optionalString isMultiMonitor ''
            UMBRIEL_MAIN_OUT='${mainName}'
            UMBRIEL_SECONDARY_OUT='${secondaryName}'
            UMBRIEL_PORTRAIT_OUT='${portraitName}'
          '';

          # Workspace names are local to each output; route launch rules explicitly.
          routeWindowRule =
            gamingOutput: rule:
            rule
            // lib.optionalAttrs isMultiMonitor (
              if (rule.default_workspace or "") == "1" && !(rule ? default_output) then
                {
                  default_output = secondaryName;
                }
              else if
                builtins.elem (rule.default_workspace or "") [
                  "2"
                  "3"
                ]
              then
                {
                  default_output = gamingOutput;
                }
              else
                { }
            );

          workSettings = (config.programs.umbriel.settings or { }) // {
            output = workOutput;
            window_rule = map (routeWindowRule secondaryName) config.programs.umbriel.settings.window_rule;
          };

          output =
            { }
            // lib.optionalAttrs (mainName != "" && isMultiMonitor) {
              "${mainName}" = (mkGamingOutput mainMon) // {
                workspaces = "dynamic";
              };
            }
            // lib.optionalAttrs (secondaryName != "" && isMultiMonitor) {
              "${secondaryName}" = (mkGamingOutput secondaryMon) // {
                workspaces = "dynamic";
              };
            }
            // lib.optionalAttrs (portraitName != "" && isMultiMonitor) {
              "${portraitName}" = (mkOutput portraitMon) // {
                workspaces = "dynamic";
              };
            }
            // lib.optionalAttrs (builtinName != "" && !isMultiMonitor) {
              "${builtinName}" = (mkOutput builtinMon) // {
                workspaces = "dynamic";
              };
            };
        in
        {
          imports = [ inputs.umbriel.homeModules.default ];

          programs.umbriel = {
            enable = true;

            settings = {
              general = {
                autostart = [
                  "noctalia"
                  "firefox"
                  "bash -c 'sleep 8 && thunderbird'"
                  "spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
                  "steam"
                ]
                ++ lib.optionals (isMultiMonitor && portraitName != "") [
                  "~/.config/umbriel/scripts/wait-for-discord-and-move.sh"
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
              };

              inherit output;

              colors = {
                shadow = "#212337FF";
                border = {
                  focused = "#37F499FF";
                  unfocused = "#A48CF2FF";
                  scratchpad_focused = "#37F499FF";
                  scratchpad_unfocused = "#A48CF2FF";
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
                  hardware_cursor = false;
                  follows_focus = true;
                };
                focus = {
                  follows_mouse = true;
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
                  0.25
                  0.5
                  0.75
                  1.0
                ];
                scrolling = {
                  default_extent_fraction = 0.95;
                  center_underfull_strip = true;
                  center_focused = "never";
                };
              };

              animation = {
                enabled = true;
                duration_ms = 200;
                beziers = {
                  easeOutQuint = [
                    0.23
                    1.0
                    0.32
                    1.0
                  ];
                  easeInOutQuint = [
                    0.83
                    0.0
                    0.17
                    1.0
                  ];
                  almostLinear = [
                    0.5
                    0.5
                    0.75
                    1.0
                  ];
                  quick = [
                    0.15
                    0.0
                    0.1
                    1.0
                  ];
                };
                springs = { };
                windows_in = {
                  enabled = true;
                  shader = "shaders/plasma-flow/open.glsl";
                  duration_ms = 250;
                  curve = "easeOutCubic";
                };
                windows_out = {
                  enabled = true;
                  shader = "shaders/plasma-flow/close.glsl";
                  duration_ms = 100;
                  curve = "easeOutCubic";
                };
                windows_move = {
                  enabled = true;
                  duration_ms = 250;
                  curve = "easeOutQuint";
                };
                workspaces = {
                  enabled = true;
                  duration_ms = 250;
                  curve = "easeInOutQuint";
                };
                overview = {
                  enabled = true;
                  duration_ms = 250;
                  curve = "easeOutQuint";
                };
                scratchpad = {
                  enabled = true;
                  duration_ms = 200;
                  curve = "easeOutQuint";
                  dim = 0.3;
                  blur = true;
                  scale = 0.0;
                };
                border = {
                  enabled = true;
                  duration_ms = 250;
                  curve = "easeOutQuint";
                };
                dim_unfocused = {
                  enabled = false;
                  duration_ms = 250;
                  curve = "easeOutQuint";
                  dim = 0.0;
                };
                layers = {
                  enabled = true;
                  duration_ms = 200;
                  curve = "easeOutQuint";
                };
              };

              overview.zoom = 0.5;

              scratchpad = [ { name = "streamcontroller"; } ];

              keybinds = {
                # Session
                "Mod+Shift+Q" = {
                  action = "session-quit:skip-confirmation";
                  repeat = false;
                };

                # Applications
                "Mod+S" = {
                  action = "spawn:~/.config/umbriel/scripts/focus-app.sh steam";
                  repeat = false;
                };
                "Mod+G" = {
                  action = "spawn:~/.config/umbriel/scripts/focus-app.sh game";
                  repeat = false;
                };
                "Mod+T" = {
                  action = "spawn:~/.config/umbriel/scripts/focus-app.sh thunderbird";
                  repeat = false;
                };
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
                  action = "window-toggle-maximize-to-edges";
                  repeat = false;
                };
                "Mod+Shift+F" = {
                  action = "window-toggle-fullscreen";
                  repeat = false;
                };
                "Mod+C" = {
                  action = "column-center";
                  repeat = false;
                };
                "Alt+Tab" = {
                  action = "spawn:~/.config/umbriel/scripts/focus-last-workspace.sh";
                  repeat = false;
                };

                # Focus
                "Mod+H" = "window-focus-or-output-left";
                "Mod+L" = "window-focus-or-output-right";
                "Mod+K" = "window-focus-or-output-up";
                "Mod+J" = "window-focus-or-output-down";
                # Arrow key focus outputs
                "Mod+Left" = "output-focus-left";
                "Mod+Right" = "output-focus-right";
                "Mod+Up" = "output-focus-up";
                "Mod+Down" = "output-focus-down";

                # Move within the strip horizontally; send to workspaces vertically.
                "Mod+Shift+H" = "column-move-left";
                "Mod+Shift+L" = "window-move-or-output-right";
                "Mod+Shift+K" = "window-move-or-workspace-up";
                "Mod+Shift+J" = "window-move-or-workspace-down";
                # Arrow key move outputs
                "Mod+Shift+Left" = "column-move-to-output-left";
                "Mod+Shift+Right" = "column-move-to-output-right";
                "Mod+Shift+Up" = "column-move-to-output-up";
                "Mod+Shift+Down" = "column-move-to-output-down";

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

                # Workspaces
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
                "Mod+D" = {
                  action = "spawn:~/.config/umbriel/scripts/focus-app.sh discord";
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
                "Mod+Shift+G" = {
                  action = "window-move-to-workspace:\"11\"";
                  repeat = false;
                };
                "Mod+Shift+D" = {
                  action = "window-move-to-workspace:${portraitWorkspace}";
                  repeat = false;
                };

                # Cycle window focus instead of switching outputs
                "Mod+WheelDown" = "window-focus-next";
                "Mod+WheelUp" = "window-focus-previous";
                "Mod+WheelLeft" = "window-focus-left";
                "Mod+WheelRight" = "window-focus-right";
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

              window_rule = map (routeWindowRule mainName) (
                [
                  # Global blur — keep first so later rules can override it
                  {
                    blur = true;
                    blur_optimized = true;
                  }

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

                  # Firefox launched during autostart lands on the browsing workspace
                  {
                    match = {
                      app_id = "^firefox$";
                      at_startup = true;
                    };
                    default_workspace = "1";
                    default_focused = false;
                  }

                  # Thunderbird
                  {
                    match = {
                      app_id = "^thunderbird$";
                      at_startup = true;
                    };
                    default_workspace = "1";
                    default_focused = false;
                  }

                  # Discord
                  (
                    {
                      match = {
                        app_id = "^discord$";
                        title = "^(?!Discord Popout$).*";
                      };
                      default_workspace = "1";
                      default_focused = false;
                      default_scrolling_column_order = 0;
                    }
                    // lib.optionalAttrs (isMultiMonitor && portraitName != "") {
                      default_output = portraitName;
                      default_scrolling_extent = 0.75;
                    }
                  )

                  # Discord popout
                  {
                    match = {
                      app_id = "^discord$";
                      title = "Discord Popout";
                    };
                    default_focused = false;
                  }

                  # StreamController
                  {
                    match.app_id = "^com.core447.StreamController$";
                    default_scratchpad = "streamcontroller";
                  }

                  # Spotify
                  (
                    {
                      match.app_id = "^spotify$";
                      default_workspace = "1";
                      default_focused = false;
                      default_scrolling_column_order = 1;
                    }
                    // lib.optionalAttrs (isMultiMonitor && portraitName != "") {
                      default_output = portraitName;
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
                  {
                    match.title = ".*(DEBUG).*";
                    default_workspace = "3";
                    default_fullscreen = true;
                  }

                  # Steam helper webpages
                  {
                    match.title = "Steamwebhelper";
                    default_workspace = "2";
                    default_focused = false;
                  }

                  # Steam notification toasts
                  {
                    match.title = "^notificationtoasts";
                    default_floating = true;
                    default_focused = false;
                    default_position = {
                      x = 0;
                      y = 0;
                      anchor = "bottom_right";
                    };
                  }

                  # Sign-in to Steam
                  {
                    match.title = "Sign in to Steam";
                    default_floating = true;
                    default_workspace = "2";
                    default_focused = false;
                  }

                  # Steam
                  (
                    {
                      match.app_id = "^steam$";
                      default_workspace = "2";
                      default_focused = false;
                      default_scrolling_extent = 1.0;
                    }
                    // lib.optionalAttrs (mainName != "") {
                      default_output = mainName;
                    }
                  )

                   # Steam Battle.net exception: prevent fullscreen for Battle.net launched as steam_app_3083450823
                   {
                     match = {
                       app_id = "^steam_app_3083450823$";
                       title  = "^Battle\\.net$";
                     };
                     default_fullscreen = false;
                     default_focused    = false;
                     default_floating   = false;
                   }
                   # Steam games
                   {
                     match.app_id       = "^steam_app_.*$";
                     default_workspace  = "3";
                     default_fullscreen = true;
                   }

                  # Lost Ark splash
                  {
                    match = {
                      app_id = "^steam_app_.*$";
                      title = "SplashScreen";
                    };
                    default_floating = true;
                    default_workspace = "3";
                    default_fullscreen = true;
                  }

                  # FFXIV
                  {
                    match.title = "FINAL FANTASY XIV";
                    default_workspace = "3";
                    default_fullscreen = true;
                  }

                  # Gamescope
                  {
                    match.app_id = "^gamescope$";
                    default_workspace = "3";
                    default_fullscreen = true;
                  }

                  # World of Warcraft (wine)
                  {
                    match.app_id = "^wow.exe$";
                    default_workspace = "3";
                    default_fullscreen = true;
                    blur = false;
                  }

                  # World of Warcraft (xwayland)
                  {
                    match.title = "World of Warcraft";
                    default_workspace = "3";
                    default_fullscreen = true;
                    blur = false;
                  }

                  # Hytale
                  {
                    match.title = "Hytale";
                    default_workspace = "3";
                    default_fullscreen = true;
                  }

                  # Battle.net
                  {
                    match.title = "^Battle.net.*";
                    default_focused = false;
                  }

                  # Battle.net gifts
                  {
                    match = {
                      app_id = "^steam_app_0$";
                      title = "Gifts";
                    };
                    default_floating = true;
                  }

                  # Battle.net whispers
                  {
                    match.title = "Battle.net.*Chats and Groups";
                    default_floating = true;
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
                    match.app_id = "^battle.net.exe$";
                    default_focused = false;
                  }

                  # Battle.net settings
                  {
                    match.title = "Battle.net Settings";
                    default_pinned = true;
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
                    default_floating = true;
                    default_pinned = true;
                    default_maximize = false;
                    default_position = {
                      x = 20;
                      y = 20;
                      anchor = "bottom_right";
                    };
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
                ]
              );

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

          systemd.user.services."workspace-history" = {
            Unit = {
              Description = "Track Umbriel workspace focus history";
              After = [ "graphical-session.target" ];
            };
            Service = {
              Type = "simple";
              ExecStart = "${config.home.homeDirectory}/nix/assets/umbriel/scripts/workspace-history.sh";
              Restart = "always";
              RestartSec = 5;
            };
            Install = {
              WantedBy = [ "graphical-session.target" ];
            };
          };

          # ------------------------------------------------------------------
          # Work-mode files
          # ------------------------------------------------------------------
          # Desktop mode file: identical to the live config; the toggle
          # script copies it back when leaving work mode.
          xdg.configFile = {
            "umbriel/config-desktop.toml".source = tomlFormat.generate "umbriel-config-desktop.toml" (
              config.programs.umbriel.settings or { }
            );

            # Work mode file: same settings with the output section swapped to
            # disable the main monitor and keep workspaces 1-12 on the
            # secondary monitor.
            "umbriel/config-work.toml".source = tomlFormat.generate "umbriel-config-work.toml" workSettings;

            # Layout map consumed by toggle-work-mode.sh to re-home tiled
            # windows after a layout switch.
            "umbriel/layout.env".text = layoutEnv;
          };

          # Runtime scripts: monitor toggle, portrait listener, and app focus shortcuts
          home.file.".config/umbriel/scripts".source =
            config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/umbriel/scripts";
          home.file.".config/umbriel/shaders".source =
            config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/umbriel/shaders";
        };
    };
}
