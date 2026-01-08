{ pkgs, lib, ... }:
{
  stylix = {
    enable = true;
    polarity = "dark";

    targets.qt = {
      enable = true;
      platform = lib.mkForce "gnome";
    };
    targets.gtk.enable = true;

    icons = {
      enable = true;
      light = "Dracula";
      dark = "Dracula";
      package = pkgs.dracula-icon-theme;
    };

    # TODO update to   base16Scheme = "${pkgs.base16-schemes}/share/themes/eldritch.yaml" when it gets updated in flake
    base16Scheme = {
      base00 = "212337";
      base01 = "323449";
      base02 = "3b4261";
      base03 = "7081d0";
      base04 = "a1abe0";
      base05 = "ebfafa";
      base06 = "f0f2f4";
      base07 = "ffffff";
      base08 = "f16c75";
      base09 = "f7c67f";
      base0A = "f1fc79";
      base0B = "37f499";
      base0C = "04d1f9";
      base0D = "04d1f9";
      base0E = "a48cf2";
      base0F = "f265b5";
    };

    fonts = {
      serif = {
        package = pkgs.roboto;
        name = "Roboto";
      };

      sansSerif = {
        package = pkgs.roboto;
        name = "Roboto";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        terminal = 16;
        applications = 13;
      };
    };
  };
}
