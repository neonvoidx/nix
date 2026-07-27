{
  den,
  inputs,
  lib,
  ...
}:
{
  den.aspects.noctalia =
    { host, user, ... }:
    {
      nixos =
        { pkgs, config, ... }:
        {
          environment.systemPackages = [
            inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
          environment.variables.QS_ICON_THEME = config.stylix.icons.${config.stylix.polarity};
          services.upower.enable = host.isLaptop or false;
        };

      homeManager =
        { ... }:
        let
          homeDir = "/home/${user.userName}";
          monitors = host.monitors or { };
          mainName = monitors.main.name or null;
          secondaryName = monitors.secondary.name or null;
          portraitName = monitors.portrait.name or null;
          builtinName = monitors.builtin.name or null;
          primaryName =
            if mainName != null then
              mainName
            else if builtinName != null then
              builtinName
            else
              "";
        in
        {
          programs.noctalia = {
            enable = true;
            systemd.enable = false;

            # if you want to read from file instead
            # settings = lib.mkForce (builtins.fromTOML (builtins.readFile ../../assets/noctalia/noctalia-config.toml));
            settings = lib.mkForce {
              audio = {
                enable_overdrive = false;
                enable_sounds = false;
              };

              bar.main = {
                capsule = true;
                capsule_foreground = "tertiary";
                center = [
                  "cat"
                  "active_window"
                ];
                contact_shadow = true;
                end = [
                  "tray"
                  "input_volume"
                  "output_volume"
                  "cat_2"
                  "ram"
                  "temp"
                  "battery"
                  "caffeine"
                  "control-center"
                  "recorder"
                  "bluetooth"
                  "brightness"
                  "wallpaper"
                  "display_mode"
                  "notifications"
                  "weather"
                  "clock"
                  "date"
                  "session"
                ];
                font_weight = 700;
                margin_edge = 5.0;
                margin_ends = 8.0;
                padding = 10;
                radius = 8;
                start = [
                  "launcher"
                  "workspaces"
                  "taskbar"
                  "left-spacer"
                  "media"
                  "audio_visualizer"
                ];
                thickness = 38;
                widget_spacing = 12;
              }
              // lib.optionalAttrs (portraitName != null) {
                monitor = {
                  ${portraitName} = {
                    enabled = false;
                    reserve_space = false;
                  };
                };
              };

              calendar = {
                enabled = true;
                account.personal_google = {
                  name = "Personal Calendar";
                  type = "google";
                };
              };

              desktop_widgets.enabled = false;

              idle = {
                behavior_order = [
                  "lock"
                  "screen-off"
                  "suspend"
                ];
                behavior = {
                  lock = {
                    action = "lock";
                    enabled = true;
                    timeout = 600;
                  };
                  screen-off = {
                    action = "screen_off";
                    enabled = true;
                    timeout = 900;
                  };
                  suspend = {
                    action = "suspend";
                    enabled = true;
                    lock_before_suspend = true;
                    timeout = 7200;
                  };
                };
              };

              location = {
                address = "Hooksett, NH";
                auto_locate = false;
              };

              lockscreen_widgets = {
                enabled = true;
                schema_version = 1;
                widget_order =
                  lib.optionals (portraitName != null) [ "lockscreen-login-box@${portraitName}" ]
                  ++ lib.optionals (secondaryName != null) [ "lockscreen-login-box@${secondaryName}" ]
                  ++ lib.optionals (mainName != null) [ "lockscreen-login-box@${mainName}" ]
                  ++ lib.optionals (builtinName != null) [ "lockscreen-login-box@${builtinName}" ]
                  ++ [
                    "lockscreen-widget-0000000000000001"
                    "lockscreen-widget-0000000000000002"
                    "lockscreen-widget-0000000000000003"
                    "lockscreen-widget-0000000000000004"
                    "lockscreen-widget-0000000000000005"
                    "lockscreen-widget-0000000000000006"
                    "lockscreen-widget-0000000000000007"
                    "lockscreen-widget-0000000000000008"
                    "lockscreen-widget-0000000000000009"
                    "lockscreen-widget-000000000000000a"
                    "lockscreen-widget-000000000000000e"
                    "lockscreen-widget-000000000000000f"
                    "lockscreen-widget-0000000000000010"
                    "lockscreen-widget-0000000000000011"
                    "lockscreen-widget-0000000000000012"
                    "lockscreen-widget-0000000000000013"
                    "lockscreen-widget-0000000000000014"
                    "lockscreen-widget-0000000000000018"
                    "lockscreen-widget-0000000000000019"
                    "lockscreen-widget-000000000000001a"
                    "lockscreen-widget-000000000000001b"
                    "lockscreen-widget-000000000000001c"
                    "lockscreen-widget-000000000000001d"
                    "lockscreen-widget-000000000000001e"
                    "lockscreen-widget-000000000000001f"
                    "lockscreen-widget-0000000000000020"
                    "lockscreen-widget-0000000000000021"
                    "lockscreen-widget-0000000000000025"
                    "lockscreen-widget-0000000000000026"
                    "lockscreen-widget-0000000000000027"
                    "lockscreen-widget-0000000000000028"
                  ];
                grid = {
                  cell_size = 8;
                  major_interval = 4;
                  visible = true;
                };
                widget =
                  lib.optionalAttrs (mainName != null) {
                    "lockscreen-login-box@${mainName}" = {
                      box_height = 229.0;
                      box_width = 720.0;
                      cx = 1728.0;
                      cy = 896.0;
                      output = mainName;
                      rotation = 0.0;
                      type = "login_box";
                      settings = {
                        background_opacity = 0.0;
                        center_password_text = false;
                        input_radius = 10.0;
                        layout = "regular";
                        show_caps_lock = true;
                        show_keyboard_layout = true;
                        show_login_button = true;
                        show_media = true;
                        show_session_buttons = true;
                        show_weather = true;
                      };
                    };
                    "lockscreen-widget-0000000000000026" = {
                      box_height = 256.0;
                      box_width = 288.0;
                      cx = 1728.0;
                      cy = 456.0;
                      output = mainName;
                      rotation = 0.0;
                      type = "sticker";
                      settings = {
                        background = false;
                        background_opacity = 0.78000000000000003;
                        background_padding = 0;
                        background_radius = 32;
                        image_path = "${homeDir}/nix/assets/neonvoid.png";
                        opacity = 1.0;
                      };
                    };
                  }
                  // lib.optionalAttrs (secondaryName != null) {
                    "lockscreen-login-box@${secondaryName}" = {
                      box_height = 229.0;
                      box_width = 720.0;
                      cx = 1728.0;
                      cy = 896.0;
                      output = secondaryName;
                      rotation = 0.0;
                      type = "login_box";
                      settings = {
                        background_opacity = 0.0;
                        center_password_text = false;
                        input_radius = 10.0;
                        layout = "regular";
                        show_caps_lock = true;
                        show_keyboard_layout = true;
                        show_login_button = true;
                        show_media = true;
                        show_session_buttons = true;
                        show_weather = true;
                      };
                    };
                    "lockscreen-widget-000000000000000e" = {
                      box_height = 224.0;
                      box_width = 640.0;
                      cx = 1720.0;
                      cy = 616.0;
                      output = secondaryName;
                      rotation = 0.0;
                      type = "clock";
                      settings = {
                        background = false;
                        background_color = "surface";
                        background_opacity = 0.42999999999999999;
                        background_padding = 10;
                        background_radius = 12;
                        center_text = false;
                        circle = true;
                        clock_style = "digital";
                        color = "primary";
                        font_family = "";
                        format = "{:%H:%M}";
                        shadow = true;
                      };
                    };
                    "lockscreen-widget-000000000000000f" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 3282.0;
                      cy = 156.89999389648438;
                      output = secondaryName;
                      rotation = 0.0;
                      type = "sysmon";
                      settings = {
                        stat = "cpu_usage";
                        stat2 = "cpu_temp";
                      };
                    };
                    "lockscreen-widget-0000000000000010" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 3275.0;
                      cy = 87.0;
                      output = secondaryName;
                      rotation = 0.0;
                      type = "label";
                      settings = {
                        background = false;
                        title = "CPU";
                      };
                    };
                    "lockscreen-widget-0000000000000011" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 3275.0;
                      cy = 296.0;
                      output = secondaryName;
                      rotation = 0.0;
                      type = "label";
                      settings = {
                        background = false;
                        title = "RAM";
                      };
                    };
                    "lockscreen-widget-0000000000000012" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 3282.0;
                      cy = 371.10000610351562;
                      output = secondaryName;
                      rotation = 0.0;
                      type = "sysmon";
                      settings = {
                        stat = "ram_pct";
                        stat2 = "";
                      };
                    };
                    "lockscreen-widget-0000000000000013" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 3275.0;
                      cy = 504.0;
                      output = secondaryName;
                      rotation = 0.0;
                      type = "label";
                      settings = {
                        background = false;
                        title = "Net";
                      };
                    };
                    "lockscreen-widget-0000000000000014" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 3282.0;
                      cy = 579.0999755859375;
                      output = secondaryName;
                      rotation = 0.0;
                      type = "sysmon";
                      settings = {
                        stat = "net_rx";
                        stat2 = "net_tx";
                      };
                    };
                    "lockscreen-widget-0000000000000018" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 142.0;
                      cy = 138.60000610351562;
                      output = secondaryName;
                      rotation = 0.0;
                      type = "weather";
                      settings = {
                        background = true;
                      };
                    };
                    "lockscreen-widget-0000000000000025" = {
                      box_height = 144.0;
                      box_width = 448.0;
                      cx = 1728.0;
                      cy = 1248.0;
                      output = secondaryName;
                      rotation = 0.0;
                      type = "media_player";
                      settings = {
                        background_radius = 18;
                      };
                    };
                    "lockscreen-widget-0000000000000027" = {
                      box_height = 256.0;
                      box_width = 288.0;
                      cx = 1736.0;
                      cy = 432.0;
                      output = secondaryName;
                      rotation = 0.0;
                      type = "sticker";
                      settings = {
                        background = false;
                        background_opacity = 0.78000000000000003;
                        background_padding = 0;
                        background_radius = 32;
                        image_path = "${homeDir}/nix/assets/neonvoid.png";
                        opacity = 1.0;
                      };
                    };
                  }
                  // lib.optionalAttrs (portraitName != null) {
                    "lockscreen-login-box@${portraitName}" = {
                      box_height = 229.0;
                      box_width = 720.0;
                      cx = 728.0;
                      cy = 1459.0;
                      output = portraitName;
                      rotation = 0.0;
                      type = "login_box";
                      settings = {
                        background_opacity = 0.0;
                        center_password_text = false;
                        input_radius = 10.0;
                        layout = "regular";
                        show_caps_lock = true;
                        show_keyboard_layout = true;
                        show_login_button = true;
                        show_media = true;
                        show_session_buttons = true;
                        show_weather = true;
                      };
                    };
                    "lockscreen-widget-0000000000000019" = {
                      box_height = 224.0;
                      box_width = 640.0;
                      cx = 720.0;
                      cy = 1176.0;
                      output = portraitName;
                      rotation = 0.0;
                      type = "clock";
                      settings = {
                        background = false;
                        background_color = "surface";
                        background_opacity = 0.42999999999999999;
                        background_padding = 10;
                        background_radius = 12;
                        center_text = false;
                        circle = true;
                        clock_style = "digital";
                        color = "primary";
                        font_family = "";
                        format = "{:%H:%M}";
                        shadow = true;
                      };
                    };
                    "lockscreen-widget-000000000000001a" = {
                      box_height = 144.0;
                      box_width = 448.0;
                      cx = 736.0;
                      cy = 1928.0;
                      output = portraitName;
                      rotation = 0.0;
                      type = "media_player";
                      settings = {
                        background_radius = 18;
                      };
                    };
                    "lockscreen-widget-000000000000001b" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 1329.5;
                      cy = 222.5;
                      output = portraitName;
                      rotation = 0.0;
                      type = "sysmon";
                      settings = {
                        stat = "cpu_usage";
                        stat2 = "cpu_temp";
                      };
                    };
                    "lockscreen-widget-000000000000001c" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 1334.0;
                      cy = 422.5;
                      output = portraitName;
                      rotation = 0.0;
                      type = "sysmon";
                      settings = {
                        stat = "ram_pct";
                        stat2 = "";
                      };
                    };
                    "lockscreen-widget-000000000000001d" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 1334.0;
                      cy = 657.5;
                      output = portraitName;
                      rotation = 0.0;
                      type = "sysmon";
                      settings = {
                        stat = "net_rx";
                        stat2 = "net_tx";
                      };
                    };
                    "lockscreen-widget-000000000000001e" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 112.0;
                      cy = 64.0;
                      output = portraitName;
                      rotation = 0.0;
                      type = "weather";
                      settings = {
                        background = true;
                      };
                    };
                    "lockscreen-widget-000000000000001f" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 1329.5;
                      cy = 146.5;
                      output = portraitName;
                      rotation = 0.0;
                      type = "label";
                      settings = {
                        background = false;
                        title = "CPU";
                      };
                    };
                    "lockscreen-widget-0000000000000020" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 1334.0;
                      cy = 349.5;
                      output = portraitName;
                      rotation = 0.0;
                      type = "label";
                      settings = {
                        background = false;
                        title = "RAM";
                      };
                    };
                    "lockscreen-widget-0000000000000021" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 1334.0;
                      cy = 584.0;
                      output = portraitName;
                      rotation = 0.0;
                      type = "label";
                      settings = {
                        background = false;
                        title = "Net";
                      };
                    };
                    "lockscreen-widget-0000000000000028" = {
                      box_height = 256.0;
                      box_width = 288.0;
                      cx = 736.0;
                      cy = 952.0;
                      output = portraitName;
                      rotation = 0.0;
                      type = "sticker";
                      settings = {
                        background = false;
                        background_opacity = 0.78000000000000003;
                        background_padding = 0;
                        background_radius = 32;
                        image_path = "${homeDir}/nix/assets/neonvoid.png";
                        opacity = 1.0;
                      };
                    };
                  }
                  // lib.optionalAttrs (builtinName != null) {
                    "lockscreen-login-box@${builtinName}" = {
                      box_height = 96.0;
                      box_width = 560.0;
                      cx = 1440.0;
                      cy = 960.0;
                      output = builtinName;
                      rotation = 0.0;
                      type = "login_box";
                      settings = {
                        background_opacity = 0.0;
                        center_password_text = false;
                        input_radius = 10.0;
                        show_caps_lock = true;
                        show_keyboard_layout = true;
                        show_login_button = true;
                      };
                    };
                  }
                  // {
                    "lockscreen-widget-0000000000000001" = {
                      box_height = 96.0;
                      box_width = 496.0;
                      cx = 1728.0;
                      cy = 1360.0;
                      output = primaryName;
                      rotation = 0.0;
                      type = "audio_visualizer";
                      settings = {
                        background = false;
                        bands = 32;
                        show_when_idle = true;
                      };
                    };
                    "lockscreen-widget-0000000000000002" = {
                      box_height = 224.0;
                      box_width = 640.0;
                      cx = 1720.0;
                      cy = 648.0;
                      output = primaryName;
                      rotation = 0.0;
                      type = "clock";
                      settings = {
                        background = false;
                        background_color = "surface";
                        background_opacity = 0.42999999999999999;
                        background_padding = 10;
                        background_radius = 12;
                        center_text = false;
                        circle = true;
                        clock_style = "digital";
                        color = "primary";
                        font_family = "";
                        format = "{:%H:%M}";
                        shadow = true;
                      };
                    };
                    "lockscreen-widget-0000000000000003" = {
                      box_height = 144.0;
                      box_width = 448.0;
                      cx = 1720.0;
                      cy = 1240.0;
                      output = primaryName;
                      rotation = 0.0;
                      type = "media_player";
                      settings = {
                        background_radius = 18;
                      };
                    };
                    "lockscreen-widget-0000000000000004" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 3274.0;
                      cy = 148.89999389648438;
                      output = primaryName;
                      rotation = 0.0;
                      type = "sysmon";
                      settings = {
                        stat = "cpu_usage";
                        stat2 = "cpu_temp";
                      };
                    };
                    "lockscreen-widget-0000000000000005" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 3274.0;
                      cy = 363.10000610351562;
                      output = primaryName;
                      rotation = 0.0;
                      type = "sysmon";
                      settings = {
                        stat = "ram_pct";
                        stat2 = "";
                      };
                    };
                    "lockscreen-widget-0000000000000006" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 3274.0;
                      cy = 571.0999755859375;
                      output = primaryName;
                      rotation = 0.0;
                      type = "sysmon";
                      settings = {
                        stat = "net_rx";
                        stat2 = "net_tx";
                      };
                    };
                    "lockscreen-widget-0000000000000007" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 134.0;
                      cy = 130.60000610351562;
                      output = primaryName;
                      rotation = 0.0;
                      type = "weather";
                      settings = {
                        background = true;
                      };
                    };
                    "lockscreen-widget-0000000000000008" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 3267.0;
                      cy = 79.0;
                      output = primaryName;
                      rotation = 0.0;
                      type = "label";
                      settings = {
                        background = false;
                        title = "CPU";
                      };
                    };
                    "lockscreen-widget-0000000000000009" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 3267.0;
                      cy = 294.20001220703125;
                      output = primaryName;
                      rotation = 0.0;
                      type = "label";
                      settings = {
                        background = false;
                        title = "RAM";
                      };
                    };
                    "lockscreen-widget-000000000000000a" = {
                      box_height = 0.0;
                      box_width = 0.0;
                      cx = 3267.0;
                      cy = 502.19998168945312;
                      output = primaryName;
                      rotation = 0.0;
                      type = "label";
                      settings = {
                        background = false;
                        title = "Net";
                      };
                    };
                  };
              };

              notification = {
                monitors = lib.pipe (host.monitors or { }) [
                  (lib.filterAttrs (_: m: !(m.isRotated or false)))
                  (lib.mapAttrsToList (_: m: m.name))
                ];
              };

              osd = {
                position = "top_center";
                scale = 1.1000000089406967;
                kinds.media = false;
              };

              plugin_settings."nightwatch75/file-search" = {
                show_hidden = true;
              };

              plugin_settings."noctalia/screen_recorder" = {
                color_range = "full";
                directory = "";
              };

              plugins = {
                enabled = [
                  "noctalia/screen_recorder"
                  "noctalia/bongocat"
                  "dotnetrob/cat"
                  "nightwatch75/file-search"
                ];
                source = [
                  {
                    kind = "git";
                    location = "https://github.com/noctalia-dev/official-plugins";
                    name = "official";
                  }
                  {
                    kind = "git";
                    location = "https://github.com/noctalia-dev/community-plugins";
                    name = "community";
                  }
                ];
              };

              accessibility.ui_scale = 1.1000000089406967;

              shell = {
                avatar_path = "${homeDir}/.face";
                font_family = "NeonMono";
                lang = "en";
                launch_apps_as_systemd_services = true;
                polkit_agent = true;
                screen_time_enabled = true;
                settings_show_advanced = true;

                greeter_sync.auto_sync = false;

                panel = {
                  borders = true;
                  control_center_placement = "floating";
                  open_near_click_control_center = true;
                  session_placement = "floating";
                  session_position = "center";
                  wallpaper_placement = "attached";
                };

                session.actions = [
                  {
                    action = "lock";
                    enabled = true;
                    shortcut = "x";
                    variant = "primary";
                  }
                  {
                    action = "command";
                    command = "${homeDir}/.nix-profile/bin/hyprshutdown";
                    enabled = true;
                    glyph = "logout";
                    label = "Logout";
                    shortcut = "l";
                    variant = "secondary";
                  }
                  {
                    action = "lock_and_suspend";
                    enabled = true;
                    label = "Lock & Suspend";
                    shortcut = "h";
                    variant = "outline";
                  }
                  {
                    action = "suspend";
                    enabled = false;
                    shortcut = "h";
                    variant = "default";
                  }
                  {
                    action = "reboot";
                    enabled = true;
                    shortcut = "r";
                    variant = "destructive";
                  }
                  {
                    action = "shutdown";
                    enabled = true;
                    shortcut = "s";
                    variant = "destructive";
                  }
                ];
              };

              theme = {
                builtin = "Eldritch";
                mode = "dark";
                source = "builtin";
              };

              wallpaper = {
                directory = "${homeDir}/pics/ultrawide";
                directory_dark = "${homeDir}/pics/ultrawide";
                directory_light = "${homeDir}/pics/ultrawide";
                per_monitor_directories = true;
                transition = [
                  "disc"
                  "fade"
                  "honeycomb"
                  "stripes"
                  "wipe"
                  "zoom"
                ];
                transition_on_startup = true;

                automation = {
                  enabled = true;
                  interval_seconds = 300;
                  recursive = false;
                };

                monitor =
                  lib.optionalAttrs (mainName != null) {
                    ${mainName} = {
                      directory = "${homeDir}/pics/ultrawide";
                      directory_dark = "${homeDir}/pics/ultrawide";
                      directory_light = "${homeDir}/pics/ultrawide";
                    };
                  }
                  // lib.optionalAttrs (secondaryName != null) {
                    ${secondaryName} = {
                      directory = "${homeDir}/pics/ultrawide";
                      directory_dark = "${homeDir}/pics/ultrawide";
                      directory_light = "${homeDir}/pics/ultrawide";
                    };
                  }
                  // lib.optionalAttrs (portraitName != null) {
                    ${portraitName} = {
                      directory = "${homeDir}/pics/vertical";
                      directory_dark = "${homeDir}/pics/vertical";
                      directory_light = "${homeDir}/pics/vertical";
                    };
                  }
                  // lib.optionalAttrs (builtinName != null) {
                    ${builtinName} = {
                      directory = "${homeDir}/pics/ultrawide";
                      directory_dark = "${homeDir}/pics/ultrawide";
                      directory_light = "${homeDir}/pics/ultrawide";
                    };
                  };
              };

              weather = {
                unit = "imperial";
              };

              widget = {
                active_window = {
                  color = "primary";
                  icon_size = 22.0;
                  max_length = 320.0;
                  title_scroll = "always";
                };
                audio_visualizer = {
                  capsule = true;
                  show_when_idle = false;
                  width = 112.0;
                };
                battery = {
                  capsule = true;
                };
                bluetooth = {
                  capsule = true;
                };
                brightness = {
                  capsule = true;
                };
                caffeine = {
                  capsule = true;
                };
                cat = {
                  input_devices = [ "/dev/input/by-id/usb-UBEST_Zoom75_Tiga_05D252E85C18-event-kbd" ];
                  type = "noctalia/bongocat:cat";
                };
                cat_2 = {
                  cat_color = "hover";
                  cat_color_mode = "custom";
                  cat_size = 39;
                  show_cpu_percent = true;
                  type = "dotnetrob/cat:cat";
                };
                clock = {
                  capsule = true;
                  capsule_foreground = "primary";
                };
                control-center = {
                  capsule = true;
                };
                cpu = {
                  capsule = true;
                };
                date = {
                  capsule = true;
                  capsule_foreground = "primary";
                  format = "{:%d %b %Y}";
                };
                display_mode = {
                  glyph = "device-projector";
                  type = "custom_button";
                  actions = {
                    left = "exec ~/.config/hypr/scripts/screen-toggle.sh 1";
                    right = "exec ~/.config/hypr/scripts/screen-toggle.sh 0";
                    scroll_up = "none";
                    scroll_down = "none";
                  };
                };
                input_volume = {
                  capsule = true;
                };
                launcher = {
                  color = "primary";
                  glyph = "bomb";
                };
                "left-spacer" = {
                  length = 25;
                  type = "spacer";
                };
                media = {
                  art_size = 56.0;
                  capsule = true;
                  capsule_foreground = "secondary";
                  hide_when_no_media = true;
                  max_length = 350.0;
                  title_scroll = "always";
                };
                network_rx = {
                  capsule = true;
                };
                network_tx = {
                  capsule = true;
                };
                notifications = {
                  capsule = true;
                };
                output_volume = {
                  capsule = true;
                };
                ram = {
                  capsule = true;
                };
                recorder = {
                  type = "noctalia/screen_recorder:recorder";
                };
                session = {
                  color = "error";
                };
                taskbar = {
                  capsule_radius = 6;
                  font_weight = 700;
                  group_by_workspace = true;
                  group_single_icon_per_app = true;
                  hide_empty_workspaces = true;
                  inactive_opacity = 0.75;
                  scale = 1.3;
                  show_workspace_label = true;
                  workspace_group_capsule = false;
                  workspace_label_placement = "inside";
                };
                temp = {
                  capsule = true;
                };
                tray = {
                  capsule = true;
                  capsule_border = "tertiary";
                  capsule_radius = 5;
                  scale = 1.3;
                };
                wallpaper = {
                  capsule = true;
                };
                workspaces = {
                  display = "none";
                  empty_color = "shadow";
                  font_weight = 700;
                  pill_scale = 0.80000000000000004;
                  scale = 1.3500000000000001;
                };
              };
            };
          };
        };
    };
}
