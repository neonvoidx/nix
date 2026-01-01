{ config, ... }:
let
  c = config.colorScheme.palette;
in
{
  programs.fzf = {
    enable = true;
    colors = {
      fg = "#${c.base05}";
      bg = "#${c.base00}";
      hl = "#${c.base0B}";
      "fg+" = "#${c.base05}";
      "bg+" = "#${c.base01}";
      "hl+" = "#${c.base0B}";
      info = "#${c.base0A}";
      prompt = "#${c.base0C}";
      pointer = "#${c.base0D}";
      marker = "#${c.base0D}";
      spinner = "#${c.base0A}";
      header = "#${c.base03}";
    };
  };
}
