{ den, inputs, ... }:
{
  den.aspects.hyprland =
    { host, ... }:
    {
      nixos =
        { pkgs, ... }:
        {
          programs.hyprland = {
            enable = true;
            # NOTE: uncomment below if using flake (master branch)
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            portalPackage =
              inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
          };
        };

      homeManager =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        let
          # Core helpers
          isMultiMonitor = host.isMultiMonitor or false;
          isVoid = host.hostName == "void";
          mkMonitor = attrs: attrs;
          lua = lib.generators.mkLuaInline;
          mkBind = args: { _args = args; };
          mkEnv = name: value: {
            _args = [
              name
              value
            ];
          };
          mkWindowRule = attrs: attrs;
          mkLayerRule = attrs: attrs;
          mkWorkspaceRule = attrs: attrs;

          # Monitor outputs and monitor helpers
          defaultMonitorOutput = "DP-2";
          portraitMonitorOutput = "HDMI-A-1";
          secondaryMonitorOutput = "DP-3";
          autoMonitorRule = mkMonitor {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = 1;
            sdr_eotf = "gamma22";
          };
          laptopMonitorRule = mkMonitor {
            output = "eDP-1";
            mode = "2880x1920@120";
            position = "0x0";
            scale = 1.33333;
            sdr_eotf = "gamma22";
          };
          disabledMonitorRule = output: {
            inherit output;
            disabled = true;
          };
          mkHdrMonitor = output: position: {
            inherit output position;
            disabled = false;
            mode = "3440x1440@143.92";
            scale = 1.0;
            bitdepth = 10;
            cm = "hdredid";
            sdrbrightness = 0.5;
            sdrsaturation = 1.0;
            sdr_max_luminance = 408;
            sdr_min_luminance = 0.2339;
            vrr = 1;
          };
          mkTouchMonitor = position: {
            output = portraitMonitorOutput;
            disabled = false;
            mode = "2560x1440@59.95";
            cm = "srgb";
            sdr_eotf = "gamma22";
            inherit position;
            scale = 1.0;
            transform = 1;
          };

          # Shared geometry and window-rule helpers
          reminderPopupSize = [
            "(monitor_w*0.2)"
            "(monitor_h*0.3)"
          ];
          reminderPopupMove = [
            "(monitor_w-(monitor_w*0.2)-10)"
            "(monitor_h-(monitor_h*0.3)-10)"
          ];
          gameWindowRuleDefaults = {
            fullscreen = true;
            suppress_event = "fullscreen";
            content = "game";
            no_max_size = true;
            no_anim = true;
            no_shadow = true;
            no_dim = true;
            border_size = 0;
            no_blur = true;
            decorate = false;
            immediate = true;
            float = false;
          };
          mkClassWorkspaceRule =
            name: class: workspace:
            mkWindowRule {
              inherit name workspace;
              match.class = class;
            };
          mkTitleWorkspaceRule =
            name: title: workspace:
            mkWindowRule {
              inherit name workspace;
              match.title = title;
            };
          mkPinnedPopupRule =
            name: match:
            mkWindowRule {
              inherit name match;
              float = true;
              pin = true;
            };
          mkFloatingRule =
            name: match: extra:
            mkWindowRule (
              {
                inherit name match;
                float = true;
              }
              // extra
            );
          mkCenteredFloatingRule =
            name: match: extra:
            mkWindowRule (
              {
                inherit name match;
                float = true;
                center = true;
              }
              // extra
            );
          mkReminderLikeRule =
            name: match: extra:
            mkWindowRule (
              {
                inherit name match;
                suppress_event = "activatefocus";
                float = true;
                pin = true;
                size = reminderPopupSize;
                move = reminderPopupMove;
              }
              // extra
            );
          mkGameRule =
            name: match:
            mkWindowRule (
              gameWindowRuleDefaults
              // {
                inherit name match;
                monitor = defaultMonitorOutput;
                workspace = "11";
              }
            );

          # Monitor layouts
          monitorLayoutPresets = {
            default = [
              (mkHdrMonitor defaultMonitorOutput "4880x1440")
              (mkHdrMonitor secondaryMonitorOutput "4880x0")
              (mkTouchMonitor "3440x727")
              autoMonitorRule
            ];
            notouch = [
              (mkHdrMonitor defaultMonitorOutput "4880x1582")
              (mkHdrMonitor secondaryMonitorOutput "4880x0")
              (mkTouchMonitor "3332x712")
              autoMonitorRule
            ];
            work = [
              (disabledMonitorRule defaultMonitorOutput)
              (mkHdrMonitor secondaryMonitorOutput "4880x0")
              (mkTouchMonitor "3440x727")
              autoMonitorRule
            ];
            work_notouch = [
              (disabledMonitorRule defaultMonitorOutput)
              (mkHdrMonitor secondaryMonitorOutput "4880x0")
              (mkTouchMonitor "2212x712")
              autoMonitorRule
            ];
          };
          defaultMonitorLayoutRules =
            if isMultiMonitor then monitorLayoutPresets.default else [ laptopMonitorRule ];

          # Workspace placement
          multiMonitorWorkspaceBaseRules = [
            {
              workspace = 3;
              monitor = portraitMonitorOutput;
              layout = "lua:portrait";
            }
            {
              workspace = 1;
              monitor = defaultMonitorOutput;
            }
            {
              workspace = 2;
              monitor = secondaryMonitorOutput;
            }
            {
              workspace = 4;
              monitor = secondaryMonitorOutput;
            }
            {
              workspace = 5;
              monitor = defaultMonitorOutput;
            }
            {
              workspace = 6;
              monitor = defaultMonitorOutput;
              layout = "floating";
            }
            {
              workspace = 10;
              monitor = defaultMonitorOutput;
            }
            {
              workspace = 11;
              monitor = defaultMonitorOutput;
            }
            {
              workspace = "name:steam";
              monitor = defaultMonitorOutput;
            }
            {
              workspace = "name:gaming";
              monitor = defaultMonitorOutput;
              no_rounding = true;
              decorate = false;
              no_border = true;
              no_shadow = true;
            }
          ];
          multiMonitorWorkspaceRules = map (
            rule:
            rule
            // {
              default = rule.default or true;
            }
          ) multiMonitorWorkspaceBaseRules;
          multiMonitorWorkspaceMonitorRules = map mkWorkspaceRule multiMonitorWorkspaceRules;

          # Bind helpers
          mkLuaBind =
            key: action:
            mkBind [
              (lua key)
              (lua action)
            ];
          mkLuaBindWith =
            key: action: extra:
            mkBind [
              (lua key)
              (lua action)
              extra
            ];
          mkExecBind = key: command: mkLuaBind key ''hl.dsp.exec_cmd("${command}")'';
          mkFocusBind = key: direction: mkLuaBind key ''hl.dsp.focus({ direction = "${direction}" })'';
          mkMoveBind = key: direction: mkLuaBind key ''hl.dsp.window.move({ direction = "${direction}" })'';
          mkWorkspaceFocusBind =
            key: workspace: mkLuaBind key ''hl.dsp.focus({ workspace = "${toString workspace}" })'';
          mkWorkspaceMoveBind =
            key: workspace: mkLuaBind key "hl.dsp.window.move({ workspace = ${toString workspace} })";
          mkLuaCommandBind =
            key: command:
            mkBind [
              key
              (lua command)
            ];
          mkExecCommandBind = key: command: mkLuaCommandBind key ''hl.dsp.exec_cmd("${command}")'';
          mkResizeBind =
            key: x: y:
            mkBind [
              key
              (lua "hl.dsp.window.resize({ x = ${toString x}, y = ${toString y}, relative = true })")
              { repeating = true; }
            ];

          # Workspace key map
          mkWorkspaceKeyBinding = key: workspace: { inherit key workspace; };
          numericWorkspaceBindings = map (
            workspace: mkWorkspaceKeyBinding (if workspace == 10 then "0" else toString workspace) workspace
          ) (lib.range 1 10);
          workspaceBindings = numericWorkspaceBindings ++ [
            (mkWorkspaceKeyBinding "d" 3)
            (mkWorkspaceKeyBinding "s" 10)
            (mkWorkspaceKeyBinding "g" 11)
          ];

          # Startup commands
          sharedStartupCommands = [
            "~/.config/hypr/scripts/restore-monitor-layout.sh"
            "noctalia-shell"
            "dbus-update-activation-environment --systemd --all && systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-hyprland.service"
            "hyprctl setcursor catppuccin-mocha-sapphire-cursors 32"
            "~/.config/hypr/scripts/save-workspace.sh"
            "xrandr --output DP-2 --primary"
            "[workspace 2 silent] firefox"
            "[workspace 4 silent] sleep 5 && thunderbird" # Gives time for protonmail bridge to startup
          ];
          spotifyStartupCommand = "spotify --enable-features=UseOzonePlatform --ozone-platform=wayland";
          startupCommands =
            sharedStartupCommands
            ++ lib.optionals isVoid [
              "[workspace 3 silent] ${spotifyStartupCommand}"
              "[workspace 10 silent] steam"
            ]
            ++ lib.optionals (!isMultiMonitor) [
              "[workspace 4 silent] ${spotifyStartupCommand}"
            ];

          # Bind groups
          screenshotBinds = [
            (mkExecCommandBind "Print" "pgrep -x hyprshot || hyprshot -z -m region --clipboard-only")
            (mkExecCommandBind "SHIFT + Print" "pgrep -x hyprshot || (hyprshot -z --clipboard-only --mode region; sleep 0.5s && wl-paste | swappy -f -)")
            (mkExecCommandBind "CTRL + Print" "pgrep -x hyprshot || hyprshot -z --mode region")
          ];
          focusDirectionBindings = [
            (mkFocusBind "mod .. \" + h\"" "left")
            (mkFocusBind "mod .. \" + left\"" "left")
            (mkFocusBind "mod .. \" + l\"" "right")
            (mkFocusBind "mod .. \" + k\"" "up")
            (mkFocusBind "mod .. \" + j\"" "down")
            (mkFocusBind "mod .. \" + right\"" "right")
          ];
          moveDirectionBindings = [
            (mkMoveBind "mod .. \" + SHIFT + h\"" "left")
            (mkMoveBind "mod .. \" + SHIFT + left\"" "left")
            (mkMoveBind "mod .. \" + SHIFT + l\"" "right")
            (mkMoveBind "mod .. \" + SHIFT + right\"" "right")
            (mkMoveBind "mod .. \" + SHIFT + k\"" "up")
            (mkMoveBind "mod .. \" + SHIFT + up\"" "up")
            (mkMoveBind "mod .. \" + SHIFT + j\"" "down")
            (mkMoveBind "mod .. \" + SHIFT + down\"" "down")
          ];
          mediaKeyBindings = [
            (mkExecCommandBind "XF86AudioRaiseVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
            (mkExecCommandBind "XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
            (mkExecCommandBind "XF86AudioMute" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
            (mkExecCommandBind "CTRL + XF86AudioMute" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
            (mkExecCommandBind "XF86AudioPlay" "playerctl play-pause")
            (mkExecCommandBind "XF86AudioPrev" "playerctl previous")
            (mkExecCommandBind "XF86AudioNext" "playerctl next")
            (mkExecCommandBind "XF86MonBrightnessUp" "brightnessctl set +5%")
            (mkExecCommandBind "XF86MonBrightnessDown" "brightnessctl set 5%-")
          ];

          # Generated Lua config
          startupLua = lib.concatStrings (
            map (command: ''
              hl.exec_cmd("${command}")
            '') startupCommands
          );
          monitorLayoutsLua =
            let
              monitorRules = lib.mapAttrs (_: rules: map mkMonitor rules) monitorLayoutPresets;
              luaFormat = lib.generators.toLua { };
            in
            /* lua */ ''
              local monitor_layouts = ${luaFormat monitorRules}

              function apply_monitor_layout(name)
                local layout = monitor_layouts[name]
                if layout == nil then
                  error("unknown monitor layout: " .. tostring(name))
                end

                for _, rule in ipairs(layout) do
                  hl.monitor(rule)
                end
              end

              function move_workspace_to_monitor(workspace, monitor)
                hl.dispatch(hl.dsp.workspace.move({ workspace = tostring(workspace), monitor = monitor }))
              end
            '';
          customLayoutsLua = /* lua */ ''
            local function target_class(target)
              local window = target.window
              if not window then
                return nil
              end

              return window.class or window.initial_class
            end

            local function is_top_window(target)
              local class = target_class(target)
              return class == "vesktop" or class == "discord"
            end

            local function is_bottom_window(target)
              local class = target_class(target)
              return class == "spotify" or class == "spicetify"
            end

            hl.layout.register("portrait", {
              recalculate = function(ctx)
                local n = #ctx.targets
                if n == 0 then
                  return
                end

                if n == 1 then
                  ctx.targets[1]:place(ctx.area)
                  return
                end

                local top = ctx.targets[1]
                local bottom = nil

                for _, target in ipairs(ctx.targets) do
                  if is_top_window(target) then
                    top = target
                    break
                  end
                end

                for _, target in ipairs(ctx.targets) do
                  if target ~= top and is_bottom_window(target) then
                    bottom = target
                    break
                  end
                end

                if not bottom then
                  for _, target in ipairs(ctx.targets) do
                    if target ~= top then
                      bottom = target
                      break
                    end
                  end
                end

                top:place(ctx:split(ctx.area, "top", 0.7))
                bottom:place(ctx:split(ctx.area, "bottom", 0.3))
              end,
            })
          '';
          defaultMonitorLayout = [ autoMonitorRule ] ++ map mkMonitor defaultMonitorLayoutRules;

          # Hyprland settings fragments
          hyprEnvironmentSettings = {
            env = [
              (mkEnv "ENABLE_HDR_WSI" "1")
              (mkEnv "DXVK_HDR" "1")
              (mkEnv "ELECTRON_OZONE_PLATFORM_HINT" "auto")
              (mkEnv "AMD_VULKAN_ICD" "RADV")
              (mkEnv "GDK_SCALE" "1")
              (mkEnv "QT_SCALE_FACTOR" "1")
              (mkEnv "GDK_BACKEND" "wayland,x11,*")
              (mkEnv "QT_QPA_PLATFORM" "wayland;xcb")
              (mkEnv "CLUTTER_BACKEND" "wayland")
              (mkEnv "QT_AUTO_SCREEN_SCALE_FACTOR" "1")
              (mkEnv "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1")
              (mkEnv "XDG_CURRENT_DESKTOP" "Hyprland")
              (mkEnv "XDG_SESSION_TYPE" "wayland")
              (mkEnv "XDG_SESSION_DESKTOP" "Hyprland")
              (mkEnv "MOZ_ENABLE_WAYLAND" "1")
              (mkEnv "EGL_PLATFORM" "wayland")
            ];
          };
          hyprMonitorSettings = {
            monitor = defaultMonitorLayout;

            workspace_rule = lib.optionals isMultiMonitor multiMonitorWorkspaceMonitorRules;
          };
          hyprBindSettings = {
            mod = {
              name = "mod";
              _var = "SUPER";
            };

            bind = [
              # App binds
              (mkExecBind "mod .. \" + SHIFT + q\"" "hyprshutdown")
              (mkExecBind "mod .. \" + Return\"" "kitty")
              # "$mod, code:49, exec, kitten quick-access-terminal"
              (mkExecBind "mod .. \" + delete\"" "noctalia-shell ipc call sessionMenu toggle")
              (mkExecBind "mod .. \" + SHIFT + delete\"" "noctalia-shell ipc call lockScreen lock")
              (mkExecBind "mod .. \" + slash\"" "noctalia-shell ipc call keybind-cheatsheet toggle")
              (mkLuaBind "mod .. \" + q\"" "hl.dsp.window.close()")
              (mkExecBind "mod .. \" + b\"" "firefox")
              (mkExecBind "mod .. \" + SHIFT + b\"" "firefox --private-window")
              (mkExecBind "mod .. \" + Space\"" "noctalia-shell ipc call launcher toggle")
              (mkExecBind "mod .. \" + v\"" "noctalia-shell ipc call launcher clipboard")
              (mkExecBind "mod .. \" + SHIFT + c\"" "pgrep -x hyprpicker > /dev/null 2>&1 && killall hyprpicker || hyprpicker -a -f hex -r")
              (mkExecBind "mod .. \" + e\"" "thunar")

              # Window management
              (mkLuaBind "mod .. \" + SHIFT + Space\"" ''hl.dsp.window.float({ action = "toggle" })'')
              (mkLuaBind "mod .. \" + SHIFT + Space\"" "hl.dsp.window.center()")
              (mkLuaBind "mod .. \" + SHIFT + f\"" "hl.dsp.window.fullscreen({action=\"toggle\",mode=\"maximized\"})")
              (mkLuaBind "mod .. \" + SHIFT + CTRL + f\"" "hl.dsp.window.fullscreen(0)")
              (mkLuaBind "mod .. \" + c\"" "hl.dsp.window.center()")
              (mkBind [
                "ALT + TAB"
                (lua "hl.dsp.focus({ last = true })")
              ])

              # Workspace switching
            ]
            ++ screenshotBinds
            ++ focusDirectionBindings
            ++ moveDirectionBindings
            ++ map (
              binding: mkWorkspaceFocusBind "mod .. \" + ${binding.key}\"" binding.workspace
            ) workspaceBindings
            ++ [

              # Move window to workspace
            ]
            ++ map (
              binding: mkWorkspaceMoveBind "mod .. \" + SHIFT + ${binding.key}\"" binding.workspace
            ) workspaceBindings
            ++ [

              # Mouse scroll workspace
              (mkLuaBind "mod .. \" + mouse_down\"" ''hl.dsp.focus({ workspace = "e+1" })'')
              (mkLuaBind "mod .. \" + mouse_up\"" ''hl.dsp.focus({ workspace = "e-1" })'')

              # Master layout
              (mkLuaBind "mod .. \" + m\"" ''hl.dsp.layout("swapwithmaster")'')
              (mkLuaBind "mod .. \" + i\"" ''hl.dsp.layout("addmaster")'')

              # Resize submap
              (mkLuaBind "mod .. \" + r\"" ''hl.dsp.submap("resize")'')

              # Mouse drag/resize
              (mkLuaBindWith "mod .. \" + mouse:272\"" "hl.dsp.window.drag()" { mouse = true; })
              (mkLuaBindWith "mod .. \" + mouse:273\"" "hl.dsp.window.resize()" { mouse = true; })
            ]
            ++ mediaKeyBindings;

            bindm = [ ];
            binde = [ ];
          };
          hyprWindowRuleSettings = {
            window_rule = [
              (mkCenteredFloatingRule "xdg-screenshare-picker" { initial_title = "Select what to share"; } { })
              (mkWindowRule {
                name = "floatingdefaults";
                match.float = true;
                size = [
                  "(monitor_w*0.85)"
                  "(monitor_h*0.80)"
                ];
                max_size = [
                  "(monitor_w*0.9)"
                  "(monitor_h*0.85)"
                ];
              })
              (mkClassWorkspaceRule "godot_all" "Godot" "6" // { float = true; })
              (mkFloatingRule "godot" {
                title = ".*(DEBUG).*";
                initial_class = "Godot";
              } { workspace = "6"; })
              (mkFloatingRule "godot_game" {
                title = ".*(DEBUG).*";
                initial_title = "Godot";
              } { workspace = "6"; })
              (mkCenteredFloatingRule "noctalia_settings" { class = "org.quickshell"; } { })
              (mkPinnedPopupRule "gnomekeyringprompt" { title = "Unlock Login Keying"; })
              (mkClassWorkspaceRule "vesktop" "vesktop" "3 silent")
              (mkClassWorkspaceRule "streamcontroller" "com.core447.StreamController"
                "special:streamcontroller silent"
              )
              (
                mkTitleWorkspaceRule "steampopup" "Steamwebhelper" "10 silent"
                // {
                  suppress_event = "activatefocus";
                }
              )
              (mkCenteredFloatingRule "steamsignin"
                {
                  initial_title = "Sign in to Steam";
                  initial_class = "steam";
                }
                {
                  suppress_event = "activatefocus";
                  workspace = "10 silent";
                }
              )
              (mkClassWorkspaceRule "steam" "steam|Steam" "10 silent" // { suppress_event = "activatefocus"; })
              (mkClassWorkspaceRule "steamgames" "^steam_app_.*$" "11" // { fullscreen = true; })
              (mkCenteredFloatingRule "lostarksplash"
                {
                  class = "^steam_app_.*$";
                  initial_title = "SplashScreen";
                }
                {
                  fullscreen = false;
                  workspace = "11";
                }
              )
              (
                mkTitleWorkspaceRule "ffxiv" "FINAL FANTASY XIV" "11"
                // {
                  float = false;
                  fullscreen = true;
                }
              )
              (mkWindowRule {
                name = "battlenetxwayland";
                match.title = "^Battle.net.*";
                float = false;
                fullscreen = false;
                fullscreen_state = "0 0";
                workspace = "10 silent";
                suppress_event = "fullscreen activatefocus";
              })
              (mkWindowRule {
                name = "bnetgifts";
                match.class = "steam_app_0";
                match.title = "Gifts";
                float = true;
                fullscreen = false;
                fullscreen_state = "0 0";
                workspace = "10";
                suppress_event = "fullscreen";
              })
              (mkWindowRule {
                name = "bnetwhispers";
                match.title = "Battle.net.*Chats and Groups";
                float = true;
                fullscreen = false;
                fullscreen_state = "0 0";
                workspace = "10";
                suppress_event = "fullscreen";
              })
              (mkWindowRule {
                name = "bnettrayiconwindow";
                match.initial_class = "explorer.exe";
                float = true;
                size = [
                  "25"
                  "25"
                ];
                move = [
                  "(monitor_w-(monitor_w*0.2)-10)"
                  "(monitor_h-(monitor_h*0.3)-10)"
                ];
                fullscreen = false;
                workspace = "10 silent";
                suppress_event = "fullscreen activatefocus";
              })
              (mkWindowRule {
                name = "battlenet";
                match.initial_class = "battle.net.exe";
                float = false;
                fullscreen = false;
                fullscreen_state = "0 0";
                workspace = "10 silent";
                suppress_event = "fullscreen activatefocus";
              })
              (mkGameRule "wow" { initial_class = "wow.exe"; })
              (mkGameRule "wowxwayland" {
                initial_class = "steam_app_0";
                title = "World of Warcraft";
              })
              (mkWindowRule {
                name = "bnettray";
                match.class = "steam_app_0";
                match.title = "^$";
                workspace = "10";
                float = true;
                fullscreen = false;
              })
              (mkWindowRule {
                name = "hytale";
                match.title = "Hytale";
                match.class = "HytaleClient";
                fullscreen = true;
                workspace = "11";
              })
              (mkReminderLikeRule "thunderbirdreminder" {
                class = "org.mozilla.Thunderbird";
                title = "^.*Reminder.*$";
              } { })
              (mkPinnedPopupRule "kittydropdown" { class = "kittyquick"; })
              (mkReminderLikeRule "pip" {
                class = "firefox";
                title = "Picture-in-Picture";
              } { no_initial_focus = true; })
              (mkFloatingRule "sgdbooppopup" { class = "SGDBoop"; } { })
              (mkWindowRule {
                name = "hyprpopup";
                match.class = "hyprland-dialog";
                pin = true;
              })
              (mkClassWorkspaceRule "gamescopegames" "gamescope" "11")
              (mkWindowRule {
                name = "xwaylandhelper";
                match.xwayland = true;
                match.title = "^$";
                match.class = "^$";
                match.initial_class = "^$";
                match.initial_title = "^$";
                opacity = "0.0";
                float = true;
                no_blur = true;
                suppress_event = "activatefocus";
              })
            ]
            ++ lib.optionals isMultiMonitor [
              (mkClassWorkspaceRule "spotify" "spotify" "3 silent")
              (mkClassWorkspaceRule "thunderbird" "org.mozilla.Thunderbird" "4 silent")
              (mkClassWorkspaceRule "fractal" "org.gnome.Fractal" "4 silent")
            ]
            ++ lib.optionals (!isMultiMonitor) [
              (mkClassWorkspaceRule "spotifyframe" "spotify" "4 silent")
            ];
          };

          # Core runtime settings
          hyprCoreSettings = {
            config = {
              input = {
                follow_mouse = 1;
                sensitivity = 0;
                scroll_factor = 1.0;
              };

              general = {
                gaps_in = 5;
                gaps_out = 8;
                border_size = 3;
                col = {
                  active_border = {
                    colors = [
                      "rgb(37f499)"
                      "rgb(04d1f9)"
                    ];
                    angle = 90;
                  };
                  inactive_border = "rgb(a48cf2)";
                  nogroup_border = "rgb(a48cf2)";
                  nogroup_border_active = "rgba(36F498FF)";
                };
                resize_on_border = true;
                layout = "master";
                extend_border_grab_area = 3;
                hover_icon_on_border = false;
              };

              animations = {
                enabled = true;
                workspace_wraparound = true;
              };

              dwindle = {
                preserve_split = true;
                force_split = 2;
                default_split_ratio = 1;
              };

              scrolling = {
                fullscreen_on_one_column = true;
                column_width = 0.6;
                direction = "right";
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
                  color = "rgb(212337)";
                };
              };

              render = {
                direct_scanout = 0;
                cm_enabled = true;
                cm_auto_hdr = 0;
              };

              misc = {
                disable_hyprland_logo = false;
                animate_manual_resizes = true;
                focus_on_activate = true;
                mouse_move_enables_dpms = true;
                key_press_enables_dpms = true;
                session_lock_xray = true;
                allow_session_lock_restore = true;
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
              }
              // lib.optionalAttrs isMultiMonitor { default_monitor = "DP-2"; };

              quirks = {
                prefer_hdr = 1;
              };
            };

            device = [
              {
                name = "logitech-wireless-mouse-pid:4099-mouse";
                scroll_factor = 0.8;
              }
            ];

            curve = [
              {
                _args = [
                  "easeOutCubic"
                  {
                    type = "bezier";
                    points = [
                      [
                        0.65
                        0
                      ]
                      [
                        0.35
                        0.8
                      ]
                    ];
                  }
                ];
              }
              {
                _args = [
                  "easeInOut"
                  {
                    type = "bezier";
                    points = [
                      [
                        0.42
                        0
                      ]
                      [
                        0.58
                        0.8
                      ]
                    ];
                  }
                ];
              }
              {
                _args = [
                  "overshoot"
                  {
                    type = "bezier";
                    points = [
                      [
                        0.05
                        0.9
                      ]
                      [
                        0.1
                        0.8
                      ]
                    ];
                  }
                ];
              }
            ];

            animation = [
              {
                leaf = "windows";
                enabled = true;
                speed = 4;
                bezier = "default";
                style = "popin";
              }
              {
                leaf = "layers";
                enabled = false;
              }
              {
                leaf = "workspaces";
                enabled = true;
                speed = 3;
                bezier = "default";
                style = "slide";
              }
            ];
          };

          hyprStartupSettings = {
            on = [
              {
                _args = [
                  "hyprland.start"
                  (lua (
                    ''
                      function()
                    ''
                    + startupLua
                    + ''
                      end
                    ''
                  ))
                ];
              }
            ];
          };

          # Layer rules
          hyprLayerRuleSettings = {
            layer_rule = [
              (mkLayerRule {
                name = "noctaliahide";
                match.namespace = "^noctalia-notifications.*$";
                no_screen_share = true;
              })
            ];
          };
        in
        {
          systemd.user.services.hypr-restore-monitor-layout = {
            Unit = {
              Description = "Restore Hyprland monitor layout from persisted state";
              # hyprland-session.target exists in typical HM Hyprland setups
              After = [
                "graphical-session.target"
                "hyprland-session.target"
              ];
              PartOf = [ "graphical-session.target" ];
            };

            Service = {
              Type = "oneshot";
              ExecStart = "%h/.config/hypr/scripts/restore-monitor-layout.sh";
            };

            Install = {
              WantedBy = [
                "hyprland-session.target"
                "graphical-session.target"
              ];
            };
          };

          wayland.windowManager.hyprland = {
            enable = true;
            # NOTE: package and portalPackage null if not using flake
            # package = null;
            # portalPackage = null;
            # NOTE: uncomment below for flake (master branch)
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            portalPackage =
              inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

            configType = "lua";
            settings = lib.mkMerge [
              # Environment
              hyprEnvironmentSettings
              # Monitors and workspace placement
              hyprMonitorSettings
              # Keybindings
              hyprBindSettings
              # Window rules
              hyprWindowRuleSettings
              # Core Hyprland settings
              hyprCoreSettings
              # Startup hooks
              hyprStartupSettings
              # Layer rules
              hyprLayerRuleSettings
            ];

            extraConfig = monitorLayoutsLua + customLayoutsLua;

            submaps.resize.settings = {
              bind = [
                (mkBind [
                  "escape"
                  (lua ''hl.dsp.submap("reset")'')
                ])
              ]
              ++ [
                (mkResizeBind "right" 20 0)
                (mkResizeBind "left" (-20) 0)
                (mkResizeBind "up" 0 20)
                (mkResizeBind "down" 0 (-20))
                (mkResizeBind "l" 20 0)
                (mkResizeBind "h" (-20) 0)
                (mkResizeBind "k" 0 20)
                (mkResizeBind "j" 0 (-20))
              ];
            };
          };

          xdg.portal = {
            extraPortals = [
              inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
              pkgs.xdg-desktop-portal-gtk
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
        };
    };
}
