{ ... }:
{
  stylix.targets = {
    cava.rainbow.enable = true;
    firefox.enable = false;
    hyprland.enable = false;
    kitty.enable = false;
    neovim.enable = false;
    nixvim.enable = false;
    noctalia-shell.enable = false;
    obsidian.enable = false;
    qt = {
      standardDialogs = "xdgdesktopportal";
    };
    spicetify.enable = false;
    yazi.colors.override = {
      base00 = "212337"; # background
      base01 = "292e42"; # current_line
      base02 = "292e42"; # selection
      base03 = "37f499"; # green (comment alternative)
      base04 = "7081d0"; # comment
      base05 = "ebfafa"; # foreground
      base06 = "ebfafa"; # light foreground
      base07 = "ebfafa"; # light background
      base08 = "f16c75"; # red
      base09 = "f7c67f"; # orange
      base0A = "f1fc79"; # yellow
      base0B = "37f499"; # green
      base0C = "04d1f9"; # cyan
      base0D = "a48cf2"; # purple (blue alternative)
      base0E = "f265b5"; # pink (magenta)
      base0F = "f7c67f"; # brown (orange)
    };
  };
}
