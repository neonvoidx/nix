{ ... }:
{
  programs.mangohud = {
    enable = true;
    settings = {
      legacy_layout = false;
      custom_text_center = "";
      round_corners = 10;
      position = "top-left";
      toggle_hud = "Shift_R+F12";
      hud_compact = true;
      pci_dev = "0:03:00.0";
      table_columns = 2;
      gpu_text = "GPU";
      cpu_text = "CPU";
      fps_text = "FPS";
      fps = true;
      fps_metrics = "avg,0.01";
      fps_limit_method = "late";
      toggle_fps_limit = "Shift_L+F1";
      fps_limit = 0;
      hdr = true;
      output_folder = /home/neonvoid;
      log_duration = 30;
      autostart_log = 0;
      log_interval = 100;
      blacklist = "zenity,protonplus,lsfg-vk-ui,bazzar,gnome-calculator,pamac-manager,lact,ghb,bitwig-studio,ptyxis,yumex";
      toggle_logging = "Shift_L+F2";
    };
  };
}
