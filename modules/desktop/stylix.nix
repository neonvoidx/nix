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
          targets.gtksourceview.enable = false;

          icons = {
            enable = true;
            light = "Eldritch-Suru-Cthulhu";
            dark = "Eldritch-Suru-Cthulhu";
            package = pkgs.eldritch-icon-theme;
          };

          cursor = {
            name = "eldritch-great-old-green-cursors";
            package = inputs.eldritch-cursors.packages.${pkgs.stdenv.hostPlatform.system}.great-old-green;
            size = 32;
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
        stylix = {
          autoEnable = true;
          targets = {
            cava.rainbow.enable = true;
            # Force qtct styling for qt dialogs
            qt = {
              platform = lib.mkForce "qtct";
              standardDialogs = "xdgdesktopportal";
            };
            # Disable the following, we already have more intricate Eldritch themes for these
            firefox.enable = false;
            hyprland.enable = false;
            kitty.enable = false;
            neovim.enable = false;
            noctalia.enable = false;
            obsidian.enable = false;
            spicetify.enable = false;
            yazi.enable = false;
          };
        };
      };
  };
}
