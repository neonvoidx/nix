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

          targets.kmscon.enable = false;
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
              name = "Roboto";
            };

            sansSerif = {
              name = "Roboto";
            };

            monospace = {
              name = "NeonMono";
            };

            emoji = {
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
          hyprland.colors.enable = false;
          hyprland.enable = true;
          kitty.enable = false;
          neovim.enable = false;
          noctalia-shell.enable = false;
          obsidian.enable = false;
          spicetify.enable = false;
          starship.enable = true;
          yazi.enable = false;
          qt = {
            platform = lib.mkForce "qtct";
            standardDialogs = "xdgdesktopportal";
          };
        };
      };
  };
}
