{ den, inputs, ... }:
{
  den.aspects.mangohud =
    { host, user, ... }:
    {
      nixos = {
        environment.sessionVariables = {
          MANGOHUD_CONFIGFILE = "/home/${user.userName}/.config/MangoHud/MangoHud.conf";
          MANGOHUD_CONFIG = "read_cfg";
        };
      };
      homeManager =
        { lib, pkgs, ... }:
        let
          mainMon = host.monitors.main or host.monitors.builtin or {};
          fpsMatch = builtins.match ".*@([0-9]+)\\.?[0-9]*" (mainMon.mode or "");
          fpsText = if fpsMatch != null then builtins.elemAt fpsMatch 0 else "60";
        in
        {
          programs.mangohud = {
            enable = true;
            settings = lib.mapAttrs (_: lib.mkForce) (
              {
                legacy_layout = false;
                blacklist = "zenity,protonplus,lsfg-vk-ui,bazzar,gnome-calculator,pamac-manager,lact,ghb,bitwig-studio,ptyxis,yumex";
                gpu_list = 0;
                gpu_stats = true;
                gpu_load_change = true;
                cpu_stats = true;
                cpu_load_change = true;
                ram = true;
                fps = true;
                frametime = 0;
                fps_text = "FPS";
                fps_color_change = true;
                toggle_logging = "Shift_L+F2";
                toggle_hud_position = "Shift_R+F11";
                output_folder = "/home/${user.userName}/";
                fps_limit_method = "late";
                toggle_fps_limit = "Shift_L+F1";
                round_corners = 15;
                background_alpha = 0.2;
                position = "top-left";
                table_columns = 2;
                toggle_hud = "Shift_R+F12";
                font_size = 16;
                font_file = "${
                  inputs.neonmono.packages.${pkgs.stdenv.hostPlatform.system}.default
                }/share/fonts/truetype/NeonMono-Medium.ttf";
                font_glyph_ranges = "korean, chinese, chinese_simplified, japanese, cyrillic, thai, vietnamese, latin_ext_a, latin_ext_b";
                gpu_color = "a48cf2";
                cpu_text = "CPU";
                cpu_color = "36f498";
                fps_value = "60,${fpsText}";
                fps_color = "f16b75,f7c67f,36f498";
                gpu_load_value = "60,90";
                gpu_load_color = "36f498,f7c67f,f16b75";
                cpu_load_value = "60,90";
                cpu_load_color = "36f498,f7c67f,f16b75";
                background_color = "212237";
                frametime_color = "00ff00";
                vram_color = "ad64c1";
                ram_color = "03d1f9";
                wine_color = "eb5b5b";
                engine_color = "c26693";
                text_color = "ffffff";
                media_player_color = "ffffff";
                network_color = "e07b85";
                battery_color = "92e79a";
                horizontal_separator_color = "ffffff";
                media_player_format = "{title};{artist};{album}";
              }
              // lib.optionalAttrs (host ? gpuPciDev) {
                pci_dev = host.gpuPciDev;
              }
            );
          };
        };
    };
}
