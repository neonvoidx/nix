{ den, inputs, ... }:
{
  den.aspects.stylix = {
    nixos =
      { pkgs, lib, ... }:
      {
        imports = [ inputs.stylix.nixosModules.stylix ];
        stylix = {
          enable = true;
          polarity = "dark";

          targets.qt = {
            enable = true;
            platform = lib.mkForce "qtct";
          };
          targets.gtk.enable = true;

          icons = {
            enable = true;
            light = "Dracula";
            dark = "Dracula";
            package = pkgs.dracula-icon-theme;
          };

          base16Scheme = "${pkgs.base16-schemes}/share/themes/eldritch.yaml";

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
      };

    homeManager =
      { lib, ... }:
      {
        stylix.targets = {
          cava.rainbow.enable = true;
          firefox.enable = false;
          hyprland.enable = true;
          hyprland.colors.enable = false;
          kitty.enable = false;
          neovim.enable = false;
          noctalia-shell.enable = false;
          obsidian.enable = false;
          yazi.enable = false;
          spicetify.enable = false;
          qt = {
            platform = lib.mkForce "qtct";
            standardDialogs = "xdgdesktopportal";
          };
        };
      };
  };
}
