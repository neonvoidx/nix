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
      { lib, config, ... }:
      let
        scheme = config.lib.stylix.colors.scheme;
        kdeTheme =
          lib.findSingle (p: builtins.match ".*stylix-kde-theme.*" (p.name or "") != null)
            (throw "stylix: no KDE theme package found in home.packages")
            (throw "stylix: multiple KDE theme packages found in home.packages")
            config.home.packages;
      in
      {
        stylix = {
          autoEnable = true;
          targets = {
            cava.rainbow.enable = true;
            nixcord = {
              enable = true;
              # Selection color carried over from the old vesktop Vencord settings
              extraCss = /* css */ ''
                    [role="textbox"] *::selection {
                      background: #7081d0 !important;
                    }
                    :root {
                    --font-primary: 'Roboto', 'Helvetica Neue', Helvetica, Arial, sans-serif !important;
                    --font-display: 'Roboto', 'Helvetica Neue', Helvetica, Arial, sans-serif !important;
                }
              '';
            };
            # Force qtct styling for qt dialogs
            qt = {
              platform = lib.mkForce "qtct";
              standardDialogs = "xdgdesktopportal";
            };
            # Disable the following, we already have more intricate Eldritch themes for these
            firefox.enable = false;
            kitty.enable = false;
            neovim.enable = false;
            noctalia.enable = false;
            obsidian.enable = false;
            rofi.enable = false;
            spicetify.enable = false;
            yazi.enable = false;
          };
        };

        # KDE Framework apps (KDE Connect, EasyEffects 8.x) take their palette
        # from kdeglobals, not qt5ct. Stylix generates <scheme>.colors but only
        # selects it from a Plasma session, which we don't run, and its
        # share/color-schemes dir is not linked into the user profile. Publish
        # the scheme and select it explicitly so those apps resolve it.
        xdg.configFile."kdeglobals" = {
          text = ''
            [General]
            ColorScheme=${scheme}
          '';
        };
        xdg.dataFile."color-schemes/${scheme}.colors".source =
          "${kdeTheme}/share/color-schemes/${scheme}.colors";
      };
  };
}
