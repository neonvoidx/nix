{ config, ... }:
let
  c = config.colorScheme.palette;
in
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "nix-colors";
    };
    themes = {
      nix-colors = ''
        # Main background
        theme[main_bg]="#${c.base00}"

        # Main text color
        theme[main_fg]="#${c.base05}"

        # Title color for boxes
        theme[title]="#${c.base05}"

        # Highlight color for keyboard shortcuts
        theme[hi_fg]="#${c.base0D}"

        # Background color of selected item in processes box
        theme[selected_bg]="#${c.base0C}"

        # Foreground color of selected item in processes box
        theme[selected_fg]="#${c.base00}"

        # Color of inactive/disabled text
        theme[inactive_fg]="#${c.base03}"

        # Color of text appearing on top of graphs
        theme[graph_text]="#${c.base05}"

        # Background color of the percentage meters
        theme[meter_bg]="#${c.base02}"

        # Misc colors for processes box
        theme[proc_misc]="#${c.base0B}"

        # Cpu box outline color
        theme[cpu_box]="#${c.base0B}"

        # Memory/disks box outline color
        theme[mem_box]="#${c.base0E}"

        # Net up/down box outline color
        theme[net_box]="#${c.base08}"

        # Processes box outline color
        theme[proc_box]="#${c.base0F}"

        # Box divider line and small boxes line color
        theme[div_line]="#${c.base02}"

        # Temperature graph colors
        theme[temp_start]="#${c.base0B}"
        theme[temp_mid]="#${c.base0C}"
        theme[temp_end]="#${c.base08}"

        # CPU graph colors
        theme[cpu_start]="#${c.base0B}"
        theme[cpu_mid]="#${c.base0E}"
        theme[cpu_end]="#${c.base0D}"

        # Mem/Disk free meter
        theme[free_start]="#${c.base0E}"
        theme[free_mid]="#${c.base0C}"
        theme[free_end]="#${c.base08}"

        # Mem/Disk cached meter
        theme[cached_start]="#${c.base0C}"
        theme[cached_mid]="#${c.base0E}"
        theme[cached_end]="#${c.base0D}"

        # Mem/Disk available meter
        theme[available_start]="#${c.base09}"
        theme[available_mid]="#${c.base0A}"
        theme[available_end]="#${c.base09}"

        # Mem/Disk used meter
        theme[used_start]="#${c.base0B}"
        theme[used_mid]="#${c.base0E}"
        theme[used_end]="#${c.base0B}"

        # Download graph colors
        theme[download_start]="#${c.base0B}"
        theme[download_mid]="#${c.base0E}"
        theme[download_end]="#${c.base0F}"

        # Upload graph colors
        theme[upload_start]="#${c.base0E}"
        theme[upload_mid]="#${c.base0C}"
        theme[upload_end]="#${c.base08}"

        # Process box color gradient
        theme[process_start]="#${c.base0E}"
        theme[process_mid]="#${c.base0B}"
        theme[process_end]="#${c.base0D}"
      '';
    };
  };
  programs.zsh.shellAliases = {
    top = "btop";
    htop = "btop";
  };
}
