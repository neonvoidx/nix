{ config, ... }:
let
  c = config.colorScheme.palette;
in
{
  programs.cava = {
    enable = true;
    settings = {
    general.framerate = 60;
    input.method = "pipewire";
    smoothing.noise_reduction = 88;
    color = {
      gradient = 1;
      gradient_color_1 = "'#${c.base0B}'";
      gradient_color_2 = "'#${c.base0C}'";
      gradient_color_3 = "'#${c.base0D}'";
      gradient_color_4 = "'#${c.base0E}'";
      gradient_color_5 = "'#${c.base0F}'";
      gradient_color_6 = "'#${c.base0A}'";
      gradient_color_7 = "'#${c.base09}'";
      gradient_color_8 = "'#${c.base08}'";
    };
  };
  };
}
