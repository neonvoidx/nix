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
        in
        {
          # --------------------------------------------------------------------------
          # Session Services
          # --------------------------------------------------------------------------

          systemd.user.services.hypr-restore-monitor-layout = {
            Unit = {
              Description = "Restore Hyprland monitor layout from persisted state";
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

            Install.WantedBy = [
              "hyprland-session.target"
              "graphical-session.target"
            ];
          };

          # --------------------------------------------------------------------------
          # Hyprland
          # --------------------------------------------------------------------------

          wayland.windowManager.hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            portalPackage =
              inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

            configType = "lua";
            extraConfig = /* lua */ ''
              local mod = "SUPER"

              local default_monitor = "DP-2"
              local secondary_monitor = "DP-3"
              local portrait_monitor = "HDMI-A-1"

              local function hdr_monitor(output, position)
                return {
                  output = output,
                  position = position,
                  disabled = false,
                  mode = "3440x1440@143.92",
                  scale = 1.0,
                  bitdepth = 10,
                  cm = "hdredid",
                  supports_hdr = 1,
                  supports_wide_color = 1,
                  sdrbrightness = 0.5,
                  sdrsaturation = 1.0,
                  sdr_max_luminance = 408,
                  sdr_min_luminance = 0.2339,
                  vrr = 1,
                }
              end

              local function portrait_monitor_rule(position)
                return {
                  output = portrait_monitor,
                  position = position,
                  disabled = false,
                  mode = "2560x1440@59.95",
                  scale = 1.0,
                  transform = 1,
                }
              end

              local auto_monitor = {
                output = "",
                mode = "preferred",
                position = "auto",
                scale = 1,
                sdr_eotf = "gamma22",
              }

              local monitor_layouts = {
                default = {
                  hdr_monitor(default_monitor, "4880x1440"),
                  hdr_monitor(secondary_monitor, "4880x0"),
                  portrait_monitor_rule("3440x727"),
                  auto_monitor,
                },
                notouch = {
                  hdr_monitor(default_monitor, "4880x1582"),
                  hdr_monitor(secondary_monitor, "4880x0"),
                  portrait_monitor_rule("3332x712"),
                  auto_monitor,
                },
                work = {
                  { output = default_monitor, disabled = true },
                  hdr_monitor(secondary_monitor, "4880x0"),
                  portrait_monitor_rule("3440x727"),
                  auto_monitor,
                },
                work_notouch = {
                  { output = default_monitor, disabled = true },
                  hdr_monitor(secondary_monitor, "4880x0"),
                  portrait_monitor_rule("2212x712"),
                  auto_monitor,
                },
              }

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

              ${
                if isMultiMonitor then
                  /* lua */ ''
                    apply_monitor_layout("default")
                  ''
                else
                  /* lua */ ''
                    hl.monitor({
                      output = "eDP-1",
                      mode = "2880x1920@120",
                      position = "0x0",
                      scale = 1.33333,
                    })
                    hl.monitor(auto_monitor)
                  ''
              }

              -- -----------------------------------------------------------------------
              -- Workspace Rules
              -- -----------------------------------------------------------------------

              ${lib.optionalString isMultiMonitor ''
                -- Primary workspace per monitor — sets the default when focusing each monitor.
                hl.workspace_rule({ workspace = 1, monitor = default_monitor, default = true })
                hl.workspace_rule({ workspace = 2, monitor = secondary_monitor, default = true })
                hl.workspace_rule({ workspace = 3, monitor = portrait_monitor, default = true, layout_opts = { orientation = "top" } })

                -- Secondary workspaces have NO monitor binding — scripts (restore/screen-toggle)
                -- handle placement dynamically based on active layout. Avoids binding conflicts
                -- when the bound monitor is disabled (e.g. DP-2 in work layouts).
                hl.workspace_rule({ workspace = 4 })
                hl.workspace_rule({ workspace = 5 })
                hl.workspace_rule({ workspace = 6, layout = "floating" })
                hl.workspace_rule({ workspace = 10 })
                hl.workspace_rule({ workspace = 11 })
                hl.workspace_rule({
                  workspace = "name:gaming",
                  no_rounding = true,
                  decorate = false,
                  no_border = true,
                  no_shadow = true,
                })
              ''}

              -- -----------------------------------------------------------------------
              -- Application Binds
              -- -----------------------------------------------------------------------

              hl.bind(mod .. " + SHIFT + q", hl.dsp.exec_cmd("hyprshutdown"))
              hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"))
              hl.bind(mod .. " + delete", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
              hl.bind(mod .. " + SHIFT + delete", hl.dsp.exec_cmd("noctalia msg screen-lock"))
              hl.bind(mod .. " + Space", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
              hl.bind(mod .. " + v", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
              hl.bind(mod .. " + bracketright", hl.dsp.exec_cmd("noctalia msg wallpaper-random"))
              hl.bind(mod .. " + b", hl.dsp.exec_cmd("firefox"))
              hl.bind(mod .. " + SHIFT + b", hl.dsp.exec_cmd("firefox --private-window"))
              hl.bind(mod .. " + SHIFT + c", hl.dsp.exec_cmd("pgrep -x hyprpicker > /dev/null 2>&1 && killall hyprpicker || hyprpicker -a -f hex -r"))
              hl.bind(mod .. " + e", hl.dsp.exec_cmd("thunar"))

              -- -----------------------------------------------------------------------
              -- Window Binds
              -- -----------------------------------------------------------------------

              hl.bind(mod .. " + q", hl.dsp.window.close())
              hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
              hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.center())
              hl.bind(mod .. " + SHIFT + f", hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" }))
              hl.bind(mod .. " + SHIFT + CTRL + f", hl.dsp.window.fullscreen(0))
              hl.bind(mod .. " + c", hl.dsp.window.center())
              hl.bind("ALT + TAB", hl.dsp.focus({ last = true }))

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
              hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
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
              hl.bind(mod .. " + d", hl.dsp.focus({ workspace = "3" }))
              hl.bind(mod .. " + s", hl.dsp.focus({ workspace = "10" }))
              hl.bind(mod .. " + g", hl.dsp.focus({ workspace = "11" }))

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
              hl.bind(mod .. " + SHIFT + d", hl.dsp.window.move({ workspace = 3 }))
              hl.bind(mod .. " + SHIFT + s", hl.dsp.window.move({ workspace = 10 }))
              hl.bind(mod .. " + SHIFT + g", hl.dsp.window.move({ workspace = 11 }))
              hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
              hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

              -- -----------------------------------------------------------------------
              -- Media And Screenshot Binds
              -- -----------------------------------------------------------------------

              hl.bind("Print", hl.dsp.exec_cmd('hyprctl keyword render:cm_enabled 0; grim -g "$(slurp -d)" - | wl-copy; hyprctl keyword render:cm_enabled 1'))
              hl.bind("SHIFT + Print", hl.dsp.exec_cmd('hyprctl keyword render:cm_enabled 0; grim -g "$(slurp)" - | satty -f - --copy-command wl-copy -o "~/Screenshots/%Y%m%d_%H%M%S.png"; hyprctl keyword render:cm_enabled 1'))
              hl.bind("CTRL + Print", hl.dsp.exec_cmd('hyprctl keyword render:cm_enabled 0; grim - | satty -f - --copy-command wl-copy -o "~/Screenshots/%Y%m%d_%H%M%S.png"; hyprctl keyword render:cm_enabled 1'))

              hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
              hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
              hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
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

              hl.window_rule({ name = "xdg-screenshare-picker", match = { initial_title = "Select what to share" }, float = true, center = true, max_size = floating_max_size })
              hl.window_rule({ name = "satty", match = { class = "com.gabm.satty" }, float = true, max_size = floating_max_size })
              hl.window_rule({ name = "noctalia_settings", match = { class = "dev.noctalia.Noctalia.Settings" }, float = true, center = true, max_size = floating_max_size, size={ "(monitor_w*0.6)", "(monitor_h*0.6)" } })
              hl.window_rule({ name = "gnomekeyringprompt", match = { title = "Unlock Login Keying" }, float = true, pin = true })
              hl.window_rule({ name = "hyprpopup", match = { class = "hyprland-dialog" }, pin = true })

              -- Invisible XWayland helper windows can briefly steal focus.
              hl.window_rule({
                name = "xwaylandhelper",
                match = { xwayland = true, title = "^$", class = "^$", initial_class = "^$", initial_title = "^$" },
                opacity = "0.0",
                float = true,
                no_blur = true,
                suppress_event = "activatefocus",
              })

              -- Workspace placement.
              hl.window_rule({ name = "vesktop", match = { class = "vesktop" }, workspace = "3 silent" })
              hl.window_rule({ name = "streamcontroller", match = { class = "com.core447.StreamController" }, workspace = "special:streamcontroller silent" })
              ${lib.optionalString isMultiMonitor /* lua */ ''
                hl.window_rule({ name = "spotify", match = { class = "spotify" }, workspace = "3 silent" })
                hl.window_rule({ name = "thunderbird", match = { class = "org.mozilla.Thunderbird" }, workspace = "4 silent" })
                hl.window_rule({ name = "fractal", match = { class = "org.gnome.Fractal" }, workspace = "4 silent" })
              ''}
              ${lib.optionalString (!isMultiMonitor) /* lua */ ''
                hl.window_rule({ name = "spotifyframe", match = { class = "spotify" }, workspace = "4 silent" })
              ''}

              -- Development.
              hl.window_rule({ name = "godot_all", match = { class = "Godot" }, workspace = "6", float = true })
              hl.window_rule({ name = "godot_game", match = { title = ".*(DEBUG).*", initial_title = "Godot" }, workspace = "11", float = true, max_size = floating_max_size })
              hl.window_rule({ name= "godot_float", match = {class="org.godotengine.Editor", float=true}, max_size = floating_max_size, center=true})

              -- Steam and games.
              hl.window_rule({ name = "steampopup", match = { title = "Steamwebhelper" }, workspace = "10 silent", suppress_event = "activatefocus" })
              hl.window_rule({ name = "steamsignin", match = { initial_title = "Sign in to Steam", initial_class = "steam" }, float = true, center = true, max_size = floating_max_size, suppress_event = "activatefocus", workspace = "10 silent" })
              hl.window_rule({ name = "steam", match = { class = "steam|Steam" }, workspace = "10 silent", suppress_event = "activatefocus" })
              hl.window_rule({ name = "steamgames", match = { class = "^steam_app_.*$" }, workspace = "11", fullscreen = true })
              hl.window_rule({ name = "lostarksplash", match = { class = "^steam_app_.*$", initial_title = "SplashScreen" }, float = true, center = true, max_size = floating_max_size, fullscreen = false, workspace = "11" })
              hl.window_rule({ name = "ffxiv", match = { title = "FINAL FANTASY XIV" }, workspace = "11", float = false, fullscreen = true })
              hl.window_rule({ name = "gamescopegames", match = { class = "gamescope" }, workspace = "11" })
              hl.window_rule({ name = "wow", match = { initial_class = "wow.exe" }, monitor = default_monitor, workspace = "11", fullscreen = true, suppress_event = "fullscreen", content = "game", no_max_size = true, no_anim = true, no_shadow = true, no_dim = true, border_size = 0, no_blur = true, decorate = false, immediate = true, float = false })
              hl.window_rule({ name = "wowxwayland", match = { initial_class = "steam_app_0", title = "World of Warcraft" }, monitor = default_monitor, workspace = "11", fullscreen = true, suppress_event = "fullscreen", content = "game", no_max_size = true, no_anim = true, no_shadow = true, no_dim = true, border_size = 0, no_blur = true, decorate = false, immediate = true, float = false })
              hl.window_rule({ name = "hytale", match = { title = "Hytale", class = "HytaleClient" }, fullscreen = true, workspace = "11" })

              -- Battle.net and Wine windows.
              hl.window_rule({ name = "battlenetxwayland", match = { title = "^Battle.net.*" }, float = false, fullscreen = false, fullscreen_state = "0 0", workspace = "10 silent", suppress_event = "fullscreen activatefocus" })
              hl.window_rule({ name = "bnetgifts", match = { class = "steam_app_0", title = "Gifts" }, float = true, fullscreen = false, fullscreen_state = "0 0", workspace = "10", suppress_event = "fullscreen" })
              hl.window_rule({ name = "bnetwhispers", match = { title = "Battle.net.*Chats and Groups" }, float = true, fullscreen = false, fullscreen_state = "0 0", workspace = "10", suppress_event = "fullscreen" })
              hl.window_rule({ name = "bnettrayiconwindow", match = { initial_class = "explorer.exe" }, float = true, size = { "25", "25" }, move = reminder_move, fullscreen = false, workspace = "10 silent", suppress_event = "fullscreen activatefocus" })
              hl.window_rule({ name = "battlenet", match = { initial_class = "battle.net.exe" }, float = false, fullscreen = false, fullscreen_state = "0 0", workspace = "10 silent", suppress_event = "fullscreen activatefocus" })
              hl.window_rule({ name = "bnettray", match = { class = "steam_app_0", title = "^$" }, workspace = "10", float = true, fullscreen = false })

              -- Floating popups and overlays.
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
                  mfact = 0.58,
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
                  direct_scanout = 1,
                  cm_enabled = true,
                  cm_auto_hdr = 0,
                  non_shader_cm = 0,
                  keep_unmodified_copy = 0,
                  use_fp16=2,
                  -- use_shader_blur_blend = true,
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
                  no_break_fs_vrr = 1,
                  enable_hyprcursor = true,
                  ${lib.optionalString isMultiMonitor "default_monitor = default_monitor,"}
                },

                quirks = {
                  prefer_hdr = 1,
                },
              })

              hl.device({ name = "logitech-wireless-mouse-pid:4099-mouse", scroll_factor = 0.8 })

              hl.curve("easeOutCubic", { type = "bezier", points = { { 0.65, 0 }, { 0.35, 0.8 } } })
              hl.curve("easeInOut", { type = "bezier", points = { { 0.42, 0 }, { 0.58, 0.8 } } })
              hl.curve("overshoot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 0.8 } } })

              hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "default", style = "popin" })
              hl.animation({ leaf = "layers", enabled = false })
              hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "default", style = "slide" })

              -- -----------------------------------------------------------------------
              -- Event Hooks
              -- -----------------------------------------------------------------------

              hl.on("hyprland.start", function()
                hl.exec_cmd("~/.config/hypr/scripts/restore-monitor-layout.sh")
                hl.exec_cmd("dbus-update-activation-environment --systemd --all && systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-hyprland.service")
                hl.exec_cmd("hyprctl setcursor catppuccin-mocha-sapphire-cursors 32")
                hl.exec_cmd("~/.config/hypr/scripts/save-workspace.sh")
                hl.exec_cmd("xrandr --output DP-2 --primary")
                hl.exec_cmd("firefox", { workspace = "2 silent" })
                hl.exec_cmd("sleep 8 && thunderbird", { workspace = "4 silent" })
                hl.exec_cmd("spotify --enable-features=UseOzonePlatform --ozone-platform=wayland", {workspace = "3 silent"})
                -- TODO: remove setpriv wrapper after Hyprland drops ambient caps internally
                -- https://github.com/hyprwm/Hyprland/discussions/14844
                hl.exec_cmd("setpriv --ambient-caps -all steam", { workspace = "10 silent" })
              end)

                ${lib.optionalString isMultiMonitor /* lua */ ''
                  hl.on("window.open", function(w)
                    if w.class ~= "vesktop" then
                      return
                    end

                    hl.dispatch(hl.dsp.window.move({ direction = "u", window = "class:vesktop" }))
                    hl.dispatch(hl.dsp.window.resize({ x = 1440, y = 2560 * 0.7, window = "class:vesktop" }))
                  end)
                ''}
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
          # Linked Hypr Assets
          # --------------------------------------------------------------------------

          home.file.".config/hypr/xdph.conf".source =
            config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/hypr/xdph.conf";
          home.file.".config/hypr/scripts".source =
            config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/hypr/scripts";
        };
    };
}
