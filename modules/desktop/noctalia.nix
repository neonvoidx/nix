{ den, inputs, ... }:
{
  den.aspects.noctalia =
    { host, ... }:
    {
      nixos =
        { pkgs, config, ... }:
        {
          environment.systemPackages = [
            inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
          environment.variables.QS_ICON_THEME = config.stylix.icons.${config.stylix.polarity};
          services.upower.enable = host.isLaptop or false;
        };

      homeManager =
        { ... }:
        {
          programs.noctalia = {
            enable = true;
            systemd.enable = true;

            settings = ../../assets/noctalia/noctalia-config.toml;
          };
        };
    };
}
