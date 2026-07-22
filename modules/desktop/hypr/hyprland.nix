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
          isMultiMonitor = host.isMultiMonitor or false;

          monitors = host.monitors or { };
          mainMon = monitors.main or { };
          secondaryMon = monitors.secondary or { };
          portraitMon = monitors.portrait or { };
          builtinMon = monitors.builtin or { };

          defaultMonitor = mainMon.name or "";
          secondaryMonitor = secondaryMon.name or "";
          portraitMonitor = portraitMon.name or "";

          mkMonitorAttrs =
            monAttrs:
            {
              output = monAttrs.name or "";
              disabled = false;
              mode = monAttrs.mode or "preferred";
              scale = monAttrs.scale or 1.0;
              position = monAttrs.position or "0x0";
              vrr = monAttrs.vrr or 0;
            }
            // lib.optionalAttrs (monAttrs ? transform) {
              transform = monAttrs.transform;
            }
            // lib.optionalAttrs (monAttrs.supports_hdr or false) {
              bitdepth = monAttrs.bitdepth or 8;
              cm = monAttrs.cm or "default";
              supports_hdr = if monAttrs.supports_hdr then 1 else 0;
              supports_wide_color = if monAttrs.supports_wide_color or false then 1 else 0;
              sdrbrightness = monAttrs.sdrbrightness or 0.5;
              sdrsaturation = monAttrs.sdrsaturation or 1.0;
              sdr_max_luminance = monAttrs.sdr_max_luminance or 400;
              sdr_min_luminance = monAttrs.sdr_min_luminance or 0.2;
            };

          toLua =
            v:
            if builtins.isString v then
              ''"${v}"''
            else if builtins.isInt v then
              toString v
            else if builtins.isFloat v then
              toString v
            else if v == true then
              "1"
            else if v == false then
              "0"
            else
              "nil";

          attrsToLua =
            attrs:
            "{ " + lib.concatStringsSep ", " (lib.mapAttrsToList (n: v: "${n} = ${toLua v}") attrs) + " }";

          monListLua =
            attrsList: lib.concatStringsSep ",\n" (map (attrs: attrsToLua (mkMonitorAttrs attrs)) attrsList);

          monLayoutsLua =
            if isMultiMonitor then
              /* lua */ ''
                local monitor_layouts = {
                  default = {
                    ${
                      monListLua [
                        mainMon
                        secondaryMon
                        portraitMon
                        {
                          output = "";
                          mode = "preferred";
                          position = "auto";
                          scale = 1.0;
                        }
                      ]
                    },
                  },
                  work = {
                    { output = "${defaultMonitor}", disabled = true },
                    ${
                      monListLua [
                        secondaryMon
                        portraitMon
                        {
                          output = "";
                          mode = "preferred";
                          position = "auto";
                          scale = 1.0;
                        }
                      ]
                    },
                  },
                }
              ''
            else
              /* lua */ ''
                local monitor_layouts = {
                  default = {
                    ${
                      monListLua [
                        builtinMon
                        {
                          output = "";
                          mode = "preferred";
                          position = "auto";
                          scale = 1.0;
                        }
                      ]
                    },
                  },
                }
              '';
        in
        {
          wayland.windowManager.hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            portalPackage =
              inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

            plugins = [ ];

            configType = "lua";
            extraConfig = /* lua */ ''
              local mod = "SUPER"
              local default_monitor = "${defaultMonitor}"
              local secondary_monitor = "${secondaryMonitor}"
              local portrait_monitor = "${portraitMonitor}"

              ${monLayoutsLua}

              ---@diagnostic disable-next-line: lowercase-global
              function apply_monitor_layout(name)
              local layout = monitor_layouts[name]
              if layout == nil then
              error("unknown monitor layout: " .. tostring(name))
              end

              for _, rule in ipairs(layout) do
              hl.monitor(rule)
              end
              end

              ---@diagnostic disable-next-line: lowercase-global
              function move_workspace_to_monitor(workspace, monitor)
              hl.dispatch(hl.dsp.workspace.move({ workspace = tostring(workspace), monitor = monitor }))
              end

              -- -----------------------------------------------------------------------
              -- Monitor helpers
              -- -----------------------------------------------------------------------

              local function is_monitor_active(name)
              local monitors = hl.get_monitors()
              if not monitors then
              return false
              end
              for _, m in ipairs(monitors) do
              if m.name == name then
              return true
              end
              end
              return false
              end

              local function move_ws_from_hdmi(ws_id)
              if ws_id == 13 then
              return
              end
              local target
              if ws_id == 10 or ws_id == 11 then
              target = is_monitor_active(default_monitor) and default_monitor or secondary_monitor
                elseif ws_id == 2 or ws_id == 12 then
                  target = secondary_monitor
                else
                  target = is_monitor_active(default_monitor) and default_monitor or secondary_monitor
                end
                hl.dispatch(hl.dsp.workspace.move({ workspace = tostring(ws_id), monitor = target, follow = false }))
              end

              local function get_ws_monitor(ws)
                if not ws then
                  return nil
                end
                    local m = ws.monitor
                    if type(m) == "table" then
                      return m.name
                    end
                      return m
                    end

                    -- -----------------------------------------------------------------------
                    -- Environment
                    -- -----------------------------------------------------------------------

                    hl.env("ENABLE_HDR_WSI", "1")
                    hl.env("DXVK_HDR", "1")
                    hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
                    hl.env("AMD_VULKAN_ICD", "RADV")
                    hl.env("GDK_SCALE", "1")
                    hl.env("QT_SCALE_FACTOR", "1")
                    hl.env("GDK_BACKEND", "wayland,x11,*")
                    hl.env("QT_QPA_PLATFORM", "wayland;xcb")
                    hl.env("CLUTTER_BACKEND", "wayland")
                    hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
                    hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
                    hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
                    hl.env("XDG_SESSION_TYPE", "wayland")
                    hl.env("XDG_SESSION_DESKTOP", "Hyprland")
                    hl.env("MOZ_ENABLE_WAYLAND", "1")
                    hl.env("EGL_PLATFORM", "wayland")
                    hl.env("HYPRLAND_TRACE", "1")
                    hl.env("AQ_TRACE", "1")

                    -- -----------------------------------------------------------------------
                        -- Monitors
                        -- -----------------------------------------------------------------------

                        apply_monitor_layout("default")

                          -- -----------------------------------------------------------------------
                          -- Workspace Rules
                          -- -----------------------------------------------------------------------

                          ${lib.optionalString isMultiMonitor /* lua */ ''
                            hl.workspace_rule({ workspace = "1", monitor = default_monitor, default = true })
                            hl.workspace_rule({ workspace = "2", monitor = secondary_monitor, default = true })
                            hl.workspace_rule({ workspace = "3", monitor = default_monitor})
                            hl.workspace_rule({ workspace = "4", monitor = default_monitor })
                            hl.workspace_rule({ workspace = "5", monitor = default_monitor })
                            hl.workspace_rule({ workspace = "6", monitor = default_monitor, layout = "floating" })
                            hl.workspace_rule({ workspace = "7", monitor = default_monitor })
                            hl.workspace_rule({ workspace = "8", monitor = default_monitor })
                            hl.workspace_rule({ workspace = "9", monitor = default_monitor })
                            hl.workspace_rule({ workspace = "10", monitor = default_monitor })
                            hl.workspace_rule({
                              workspace = "11",
                              monitor = default_monitor,
                              no_rounding = true,
                              decorate = false,
                              no_border = true,
                              no_shadow = true,
                            })
                            hl.workspace_rule({ workspace = "12", monitor = secondary_monitor })
                            hl.workspace_rule({ workspace = "13", monitor = ${
                              if portraitMonitor != "" then "portrait_monitor" else "default_monitor"
                            }, default = true, layout = "master", layout_opts = { orientation = "top" } })
                          ''}

                          -- -----------------------------------------------------------------------
                          -- Application Binds
                          -- -----------------------------------------------------------------------

                          hl.bind(mod .. " + SHIFT + q", hl.dsp.exec_cmd("hyprshutdown"))
                          hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"))
                          hl.bind(mod .. " + delete", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
                          hl.bind(mod .. " + SHIFT + delete", hl.dsp.exec_cmd("noctalia msg session lock"))
                          hl.bind(mod .. " + Space", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
                          hl.bind(mod .. " + v", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
                          hl.bind(mod .. " + bracketright", hl.dsp.exec_cmd("noctalia msg wallpaper-random"))
                          hl.bind(mod .. " + b", hl.dsp.exec_cmd("firefox"))
                          hl.bind(mod .. " + SHIFT + b", hl.dsp.exec_cmd("firefox --private-window"))
                          hl.bind(mod .. " + SHIFT + c", hl.dsp.exec_cmd("pgrep -x hyprpicker > /dev/null 2>&1 && killall hyprpicker || hyprpicker -a -f hex -r"))
                          hl.bind(mod .. " + e", hl.dsp.exec_cmd("thunar"))
                          hl.bind(mod .. " + o", hl.dsp.exec_cmd("obsidian"))

                          -- -----------------------------------------------------------------------
                          -- Window Binds
                          -- -----------------------------------------------------------------------

                          hl.bind(mod .. " + q", hl.dsp.window.close())
                          hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
                          hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.center())
                          hl.bind(mod .. " + f", hl.dsp.window.fullscreen({ mode="maximized", action = "toggle" }))
                          hl.bind(mod .. " + SHIFT + f", hl.dsp.window.fullscreen({ mode="fullscreen", action = "toggle" }))
                          hl.bind(mod .. " + c", hl.dsp.window.center())
                          hl.bind("ALT + TAB", hl.dsp.focus({ workspace = "previous" }))

                          hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
                          hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
                          hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))
                          hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
                          hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
                          hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))

                            hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
                            hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
                            hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
                            hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
                            hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
                            hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
                            hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
                            hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

                            hl.bind(mod .. " + m", hl.dsp.layout("swapwithmaster"))
                            hl.bind(mod .. " + i", hl.dsp.layout("addmaster"))
                            hl.bind(mod .. " + r", hl.dsp.submap("resize"))
                            hl.bind(mod .. " + equal", hl.dsp.layout("mfact +0.05"), { repeating = true })
                            hl.bind(mod .. " + minus", hl.dsp.layout("mfact -0.05"), { repeating = true })
                            hl.bind(mod .. " + mouse:272", function()
                              local w = hl.get_active_window()
                              if w then
                                local cls = w.class
                                if cls and (cls:match("^steam_app_") or cls == "gamescope" or cls == "wow.exe") then return end
                                hl.dispatch(hl.dsp.window.drag())
                              end
                            end, { mouse = true })
                            hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

                              -- -----------------------------------------------------------------------
                              -- Workspace Binds
                              -- -----------------------------------------------------------------------

                              hl.bind(mod .. " + 1", hl.dsp.focus({ workspace = "1" }))
                              hl.bind(mod .. " + 2", hl.dsp.focus({ workspace = "2" }))
                              hl.bind(mod .. " + 3", hl.dsp.focus({ workspace = "3" }))
                              hl.bind(mod .. " + 4", hl.dsp.focus({ workspace = "4" }))
                              hl.bind(mod .. " + 5", hl.dsp.focus({ workspace = "5" }))
                              hl.bind(mod .. " + 6", hl.dsp.focus({ workspace = "6" }))
                              hl.bind(mod .. " + 7", hl.dsp.focus({ workspace = "7" }))
                              hl.bind(mod .. " + 8", hl.dsp.focus({ workspace = "8" }))
                              hl.bind(mod .. " + 9", hl.dsp.focus({ workspace = "9" }))
                              hl.bind(mod .. " + 0", hl.dsp.focus({ workspace = "10" }))
                              hl.bind(mod .. " + d", function()
                                local wins = hl.get_windows()
                                if wins then
                                  for _, w in ipairs(wins) do
                                    if w.class and w.class:match("vesktop") then
                                      hl.dispatch(hl.dsp.focus({ window = "class:vesktop" }))
                                      return
                                    end
                                  end
                                end
                                hl.dispatch(hl.dsp.focus({ workspace = "13" }))
                              end)
                              hl.bind(mod .. " + s", hl.dsp.focus({ workspace = "10" }))
                              hl.bind(mod .. " + g", hl.dsp.focus({ workspace = "11" }))
                              hl.bind(mod .. " + t", hl.dsp.focus({ workspace = "12" }))

                              hl.bind(mod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
                              hl.bind(mod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
                              hl.bind(mod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
                              hl.bind(mod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
                              hl.bind(mod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
                              hl.bind(mod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
                              hl.bind(mod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
                              hl.bind(mod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
                              hl.bind(mod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
                              hl.bind(mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
                              hl.bind(mod .. " + SHIFT + d", hl.dsp.window.move({ workspace = 13 }))
                              hl.bind(mod .. " + SHIFT + s", hl.dsp.window.move({ workspace = 10 }))
                              hl.bind(mod .. " + SHIFT + g", hl.dsp.window.move({ workspace = 11 }))
                              hl.bind(mod .. " + SHIFT + t", hl.dsp.window.move({ workspace = 12 }))
                              hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
                              hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

                              -- -----------------------------------------------------------------------
                              -- Media And Screenshot Binds
                              -- -----------------------------------------------------------------------

                              hl.bind("Print", hl.dsp.exec_cmd('wayfreeze & PID=$!; sleep .1; grim -g "$(slurp -d)" - | wl-copy; kill $PID'))
                              hl.bind("SHIFT + Print", hl.dsp.exec_cmd('wayfreeze & PID=$!; sleep .1; grim -g "$(slurp)" /tmp/.screenshot-tmp.png; kill $PID; satty -f /tmp/.screenshot-tmp.png --copy-command wl-copy -o "~/Screenshots/%Y%m%d_%H%M%S.png"'))
                              hl.bind("CTRL + Print", hl.dsp.exec_cmd('wayfreeze & PID=$!; sleep .1; grim /tmp/.screenshot-tmp.png; kill $PID; satty -f /tmp/.screenshot-tmp.png --copy-command wl-copy -o "~/Screenshots/%Y%m%d_%H%M%S.png"'))
                              hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
                              hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
                              hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
                              hl.bind("CTRL + XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+"))
                              hl.bind("CTRL + XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-"))
                              hl.bind("CTRL + XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
                              hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
                              hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
                              hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
                              hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"))
                              hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))

                              -- -----------------------------------------------------------------------
                              -- Resize Submap
                              -- -----------------------------------------------------------------------

                              hl.define_submap("resize", function()
                                hl.bind("escape", hl.dsp.submap("reset"))
                                hl.bind("right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
                                hl.bind("left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
                                hl.bind("up", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
                                hl.bind("down", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
                                hl.bind("l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
                                hl.bind("h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
                                hl.bind("k", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
                                hl.bind("j", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
                              end)

                              -- -----------------------------------------------------------------------
                              -- Window Rules
                              -- -----------------------------------------------------------------------

                              local reminder_size = { "(monitor_w*0.2)", "(monitor_h*0.3)" }
                              local reminder_move = { "(monitor_w-(monitor_w*0.2)-10)", "(monitor_h-(monitor_h*0.3)-10)" }
                              local floating_max_size = { "(monitor_w*0.8)", "(monitor_h*0.8)" }
                              local floating_default_size = { "(monitor_w*0.6)", "(monitor_h*0.6)" }

                              hl.window_rule({ name = "blender-file", match = { initial_title = "File Browser", class="blender" }, float = true, center = true, max_size = floating_max_size, size = floating_default_size })

                              hl.window_rule({ name = "xdg-screenshare-picker", match = { initial_title = "Select what to share" }, float = true, center = true, max_size = floating_max_size })
                              hl.window_rule({ name = "satty", match = { class = "com.gabm.satty" }, float = true, max_size = floating_max_size })
                              hl.window_rule({ name = "noctalia_settings", match = { class = "dev.noctalia.Noctalia", title="Noctalia Settings" }, float = true, center = true, max_size = floating_max_size, size=floating_default_size })
                              hl.window_rule({ name = "xdgfilepicker", match = { class = "xdg-desktop-portal-gtk" }, float = true, center = true, size = floating_default_size, max_size = floating_max_size })
                              hl.window_rule({ name = "gnomekeyringprompt", match = { title = "Unlock Login Keying" }, float = true, pin = true })
                              hl.window_rule({ name = "hyprpopup", match = { class = "hyprland-dialog" }, pin = true })
                              hl.window_rule({name="thunderbird", match={class="thunderbird"}, workspace="12 silent", suppress_event="activatefocus"})
                              hl.window_rule({
                                name = "xwaylandhelper",
                                match = { xwayland = true, title = "^$", class = "^$", initial_class = "^$", initial_title = "^$" },
                                opacity = "0.0",
                                float = true,
                                no_blur = true,
                                suppress_event = "activatefocus",
                              })
                              hl.window_rule({ name = "vesktop", match = { class = "vesktop" }, workspace = "13 silent" })
                              hl.window_rule({ name = "discord-popout", match = { class = "vesktop", initial_title = "Discord Popout" }, workspace = "2 silent" })
                              hl.window_rule({ name = "streamcontroller", match = { class = "com.core447.StreamController" }, workspace = "special:streamcontroller silent" })
                              ${lib.optionalString isMultiMonitor /* lua */ ''
                                hl.window_rule({ name = "spotify", match = { class = "spotify" }, workspace = "13 silent" })
                                hl.window_rule({ name = "fractal", match = { class = "org.gnome.Fractal" }, workspace = "12 silent" })
                              ''}
                              ${lib.optionalString (!isMultiMonitor) /* lua */ ''
                                hl.window_rule({ name = "spotifyframe", match = { class = "spotify" }, workspace = "12 silent" })
                              ''}

                              hl.window_rule({ name = "godot_all", match = { class = "Godot" }, workspace = "6", float = true })
                              hl.window_rule({ name = "godot_game", match = { title = ".*(DEBUG).*", initial_title = "Godot" }, workspace = "11", float = true, max_size = floating_max_size })
                              hl.window_rule({ name= "godot_float", match = {class="org.godotengine.*", float=true}, max_size = floating_max_size, center=true, size=floating_default_size})

                              hl.window_rule({ match = { content = "game", fullscreen = true }, confine_pointer = true })
                              hl.window_rule({ name = "steampopup", match = { title = "Steamwebhelper" }, workspace = "10 silent", suppress_event = "activatefocus" })
                              hl.window_rule({ name = "steamnotification", match = { class = "steam", title = "^notificationtoasts" }, pin=true, suppress_event = "activatefocus", float=true })
                              hl.window_rule({ name = "steamsignin", match = { initial_title = "Sign in to Steam", initial_class = "steam" }, float = true, center = true, max_size = floating_max_size, suppress_event = "activatefocus", workspace = "10 silent" })
                              hl.window_rule({ name = "steam", match = { class = "steam|Steam" }, workspace = "10 silent", suppress_event = "activatefocus" })
                              hl.window_rule({ name = "steamgames", match = { class = "^steam_app_.*$" }, workspace = "11", fullscreen = true, content="game"})
                              hl.window_rule({ name = "lostarksplash", match = { class = "^steam_app_.*$", initial_title = "SplashScreen" }, float = true, center = true, max_size = floating_max_size, fullscreen = false, workspace = "11" })
                              hl.window_rule({ name = "ffxiv", match = { title = "FINAL FANTASY XIV" }, workspace = "11", float = false, fullscreen = true, content="game"  })
                              hl.window_rule({ name = "gamescopegames", match = { class = "gamescope" }, workspace = "11" })
                              hl.window_rule({ name = "wow", match = { initial_class = "wow.exe" }, monitor = default_monitor, workspace = "11", fullscreen = true, suppress_event = "fullscreen", content = "game", no_max_size = true, no_anim = true, no_shadow = true, no_dim = true, border_size = 0, no_blur = true, decorate = false, immediate = true, float = false})
                              hl.window_rule({ name = "wowxwayland", match = { initial_class = "steam_app_0", title = "World of Warcraft" }, monitor = default_monitor, workspace = "11", fullscreen = true, suppress_event = "fullscreen", content = "game", no_max_size = true, no_anim = true, no_shadow = true, no_dim = true, border_size = 0, no_blur = true, decorate = false, immediate = true, float = false})
                              hl.window_rule({ name = "hytale", match = { title = "Hytale", class = "HytaleClient" }, fullscreen = true, workspace = "11" , content="game"})

                              hl.window_rule({ name = "battlenetxwayland", match = { title = "^Battle.net.*" }, float = false, fullscreen = false, fullscreen_state = "0 0", workspace = "10 silent", suppress_event = "fullscreen activatefocus" })
                              hl.window_rule({ name = "bnetgifts", match = { class = "steam_app_0", title = "Gifts" }, float = true, fullscreen = false, fullscreen_state = "0 0", workspace = "10", suppress_event = "fullscreen" })
                              hl.window_rule({ name = "bnetwhispers", match = { title = "Battle.net.*Chats and Groups" }, float = true, fullscreen = false, fullscreen_state = "0 0", workspace = "10", suppress_event = "fullscreen" })
                              hl.window_rule({ name = "bnettrayiconwindow", match = { initial_class = "explorer.exe" }, float = true, size = { "25", "25" }, move = reminder_move, fullscreen = false, workspace = "10 silent", suppress_event = "fullscreen activatefocus" })
                              hl.window_rule({ name = "battlenet", match = { initial_class = "battle.net.exe" }, float = false, fullscreen = false, fullscreen_state = "0 0", workspace = "10 silent", suppress_event = "fullscreen activatefocus" })
                              hl.window_rule({ name = "bnettray", match = { class = "steam_app_0", title = "^$" }, workspace = "10", float = true, fullscreen = false })

                              hl.window_rule({ name = "thunderbirdreminder", match = { class = "org.mozilla.Thunderbird", title = "^.*Reminder.*$" }, suppress_event = "activatefocus", float = true, pin = true, size = reminder_size, move = reminder_move, max_size = floating_max_size })
                              hl.window_rule({ name = "kittydropdown", match = { class = "kittyquick" }, float = true, pin = true })
                              hl.window_rule({ name = "pip", match = { class = "firefox", title = "Picture-in-Picture" }, suppress_event = "activatefocus", float = true, pin = true, size = reminder_size, move = reminder_move, max_size = floating_max_size, no_initial_focus = true })
                              hl.window_rule({ name = "sgdbooppopup", match = { class = "SGDBoop" }, float = true, max_size = floating_max_size })

                              -- -----------------------------------------------------------------------
                              -- Layer Rules
                              -- -----------------------------------------------------------------------

                              hl.layer_rule({ name = "noctaliahide", match = { namespace = "^noctalia-notification$" }, no_screen_share = true })

                              -- -----------------------------------------------------------------------
                              -- Core Hyprland Settings
                              -- -----------------------------------------------------------------------

                              hl.config({
                                input = {
                                  follow_mouse = 1,
                                  sensitivity = 0,
                                  scroll_factor = 1.0,
                                },

                                general = {
                                  gaps_in = 5,
                                  gaps_out = 8,
                                  border_size = 3,
                                  resize_on_border = true,
                                  layout = "master",
                                  extend_border_grab_area = 3,
                                  hover_icon_on_border = false,
                                  col = {
                                    active_border = {
                                      colors = { "rgb(37f499)", "rgb(04d1f9)" },
                                      angle = 90,
                                    },
                                    inactive_border = "rgb(a48cf2)",
                                    nogroup_border = "rgb(a48cf2)",
                                    nogroup_border_active = "rgba(36F498FF)",
                                  },
                                },

                                animations = {
                                  enabled = true,
                                  workspace_wraparound = true,
                                },

                                dwindle = {
                                  preserve_split = true,
                                  force_split = 2,
                                  default_split_ratio = 1,
                                },

                                scrolling = {
                                  fullscreen_on_one_column = true,
                                  column_width = 0.6,
                                  direction = "right",
                                },

                                master = {
                                  new_status = "slave",
                                  new_on_top = false,
                                  allow_small_split = false,
                                  mfact = 0.60,
                                },

                                decoration = {
                                  rounding = 8,
                                  dim_inactive = true,
                                  dim_strength = 5.0e-2,
                                  blur = {
                                    enabled = true,
                                    size = 8,
                                    passes = 1,
                                    new_optimizations = true,
                                    ignore_opacity = true,
                                    xray = true,
                                  },
                                  shadow = {
                                    enabled = true,
                                    range = 4,
                                    render_power = 3,
                                    color = "rgb(212337)",
                                  },
                                },

                                render = {
                                  direct_scanout = 2,
                                  cm_auto_hdr = 0,
                                  non_shader_cm = 2,
                                },

                                misc = {
                                  disable_hyprland_logo = false,
                                  animate_manual_resizes = true,
                                  focus_on_activate = true,
                                  mouse_move_enables_dpms = true,
                                  key_press_enables_dpms = true,
                                  session_lock_xray = true,
                                  allow_session_lock_restore = true,
                                },

                                xwayland = {
                                  force_zero_scaling = true,
                                },

                                debug = {
                                  disable_logs = false,
                                },

                                ecosystem = {
                                  no_update_news = true,
                                  no_donation_nag = true,
                                },

                                cursor = {
                                  sync_gsettings_theme = true,
                                  no_break_fs_vrr = 2,
                                  min_refresh_rate = 60,
                                  enable_hyprcursor = true,
                                  no_hardware_cursors = 1,
                                  ${lib.optionalString isMultiMonitor "default_monitor = \"${defaultMonitor}\","}
                                },
                              })

                              hl.device({ name = "logitech-wireless-mouse-pid:4099-mouse", scroll_factor = 0.8 })

                              -- Animations
                              -- Curves
                              -- ## Beziers
                              hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
                              hl.curve("easeInOutQuint", { type = "bezier", points = { { 0.83, 0 }, { 0.17, 1 } } })
                              hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
                              hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
                              hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
                              hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

                              -- ## Springs
                              hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })


                              -- Animations
                              hl.animation({ leaf = "global", enabled = true, speed = 5, bezier = "default" })
                              hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
                              hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "linear", style = "loop" })

                              -- ## Windows
                              hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
                              hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
                              hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
                              hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
                              hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
                              hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })

                              -- ## Layers
                              hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
                              hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
                              hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
                              hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
                              hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })

                              -- ## Workspaces
                              hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "easeInOutQuint", style = "slide" })
                              hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2.5, bezier = "easeInOutQuint", style = "slide" })
                              hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.5, bezier = "easeInOutQuint", style = "slide" })

                              -- ## Zoom
                              hl.animation({ leaf = "zoomFactor", enabled = true, speed = 3.5, bezier = "quick" })

                              -- -----------------------------------------------------------------------
                              -- Event Hooks
                              -- -----------------------------------------------------------------------

                              hl.on("window.open", function(w)
                                local ws = w.workspace
                                if ws and get_ws_monitor(ws) == portrait_monitor and ws.id ~= 13 then
                                  move_ws_from_hdmi(ws.id)
                                end
                              end)

                              hl.on("window.move_to_workspace", function(w, ws)
                                if ws and get_ws_monitor(ws) == portrait_monitor and ws.id ~= 13 then
                                  move_ws_from_hdmi(ws.id)
                                end
                              end)

                              hl.on("workspace.active", function(ws)
                                if not ws then return end

                                local mon = get_ws_monitor(ws)
                                if mon == portrait_monitor and ws.id ~= 13 then
                                  move_ws_from_hdmi(ws.id)
                                end
                              end)

                              hl.on("monitor.added", function()
                                local workspaces = hl.get_workspaces()
                                if not workspaces then
                                  return
                                end
                                for _, ws in ipairs(workspaces) do
                                  local mon = get_ws_monitor(ws)
                                  if mon == portrait_monitor and ws.id ~= 13 then
                                    move_ws_from_hdmi(ws.id)
                                  end
                                end
                                -- Delayed full restore to catch workspaces Hyprland shuffles
                                -- onto wrong monitors after all monitors settle (session-lock
                                -- restore, post-resume reallocation, etc.).
                                hl.exec_cmd("(sleep 2 && ~/.config/hypr/scripts/restore-monitor-layout.sh \"${defaultMonitor}\" \"${secondaryMonitor}\" \"${portraitMonitor}\") &")
                              end)

                              hl.on("hyprland.start", function()
                                hl.exec_cmd("noctalia")
                                hl.exec_cmd("~/.config/hypr/scripts/restore-monitor-layout.sh \"${defaultMonitor}\" \"${secondaryMonitor}\" \"${portraitMonitor}\"")
                                hl.exec_cmd("systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-hyprland.service")
                                hl.exec_cmd("hyprctl setcursor eldritch-great-old-green-cursors 32")
                                hl.exec_cmd("~/.config/hypr/scripts/save-workspace.sh")
                                hl.exec_cmd("xrandr --output ${defaultMonitor} --primary")
                                hl.exec_cmd("firefox", { workspace = "2 silent" })
                                hl.exec_cmd("sleep 8 && thunderbird", { workspace = "12 silent" })
                                hl.exec_cmd("spotify --enable-features=UseOzonePlatform --ozone-platform=wayland", {workspace = "13 silent"})
                                hl.exec_cmd("steam", { workspace = "10 silent" })
                                ${lib.optionalString (portraitMonitor != "") /* lua */ ''
                                  hl.exec_cmd("~/.config/hypr/scripts/wait-for-vesktop-and-move.sh")
                                ''}
                              end)
            '';
          };

          # --------------------------------------------------------------------------
          # XDG Portals
          # --------------------------------------------------------------------------
          xdg.portal = {
            extraPortals = [
              inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
              pkgs.xdg-desktop-portal-gtk
            ];
            config.hyprland = {
              default = [
                "hyprland"
                "gtk"
              ];
              "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            };
          };

          # --------------------------------------------------------------------------
          # Resume hook — restore xrandr primary after suspend
          # because steam games (xwayland) rely on xrandr primary for resolution sometimes o.O
          # --------------------------------------------------------------------------

          systemd.user.services."restore-xrandr-primary" = {
            Unit = {
              Description = "Restore xrandr primary monitor after resume";
              After = [ "graphical-session.target" ];
            };
            Service = {
              Type = "oneshot";
              ExecStart = "%h/.config/hypr/scripts/restore-xrandr-primary.sh \"${defaultMonitor}\" \"${secondaryMonitor}\"";
              RemainAfterExit = true;
            };
            Install = {
              WantedBy = [
                "graphical-session.target"
                "sleep.target"
              ];
            };
          };

          # --------------------------------------------------------------------------
          # Resume hook — restore workspace-to-monitor bindings after suspend
          # --------------------------------------------------------------------------

          systemd.user.services."restore-monitor-layout-after-resume" = {
            Unit = {
              Description = "Restore workspace-to-monitor bindings after resume";
              After = [ "graphical-session.target" ];
            };
            Service = {
              Type = "oneshot";
              ExecStart = "%h/.config/hypr/scripts/restore-monitor-layout.sh \"${defaultMonitor}\" \"${secondaryMonitor}\" \"${portraitMonitor}\"";
              RemainAfterExit = true;
            };
            Install = {
              WantedBy = [
                "graphical-session.target"
                "sleep.target"
              ];
            };
          };

          # --------------------------------------------------------------------------
          # Linked Hypr Assets
          # --------------------------------------------------------------------------

          home.file.".config/hypr/xdph.conf".source =
            config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/hypr/xdph.conf";
          home.file.".config/hypr/scripts".source =
            config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/hypr/scripts";
        };
    };
}
