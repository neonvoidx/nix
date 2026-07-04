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
        { lib, ... }:
        {
          programs.noctalia = {
            enable = true;
            systemd.enable = false;

            settings = lib.mkForce (builtins.fromTOML (builtins.readFile ../../assets/noctalia/noctalia-config.toml));
          };
        };
    };
}
