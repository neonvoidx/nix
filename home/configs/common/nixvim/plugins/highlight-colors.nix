{ ... }:
{
  plugins.nvim-colorizer = {
    enable = true;
    settings = {
      user_commands = true;
      user_default_options = {
        mode = "virtualtext";
        names = false;
        virtualtext = "■ ";
        RGB = true;
        RGBA = true;
        RRGGBB = true;
        RRGGBBAA = true;
        AARRGGBB = true;
        rgb_fn = true;
        hsl_fn = true;
        oklch_fn = true;
        css = true;
        css_fn = true;
        tailwind = true;
        xterm = true;
      };
    };
  };
}
