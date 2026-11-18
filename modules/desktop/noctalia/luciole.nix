{ den, inputs, ... }:
{
  den.aspects.luciole = {
    nixos =
      { pkgs, ... }:
      {
        services.gvfs.enable = true;
        xdg.portal = {
          extraPortals = [ inputs.luciole.packages.${pkgs.stdenv.hostPlatform.system}.default ];
          config = {
            common."org.freedesktop.impl.portal.FileChooser" = [
              "luciole"
              "gtk"
            ];
            umbriel."org.freedesktop.impl.portal.FileChooser" = [
              "luciole"
              "gtk"
            ];
          };
        };
      };

    homeManager = {
      imports = [ inputs.luciole.homeModules.default ];
      programs.luciole = {
        enable = true;
        settings.browser = {
          background_opacity = 0.9;
          grid_icon_size = 256;
          show_hidden = true;
          show_size_caption = true;
          typing_mode = "typeahead";
          view_mode = "grid";
        };
      };
    };
  };
}
