{ den, inputs, ... }:
{
  den.aspects.hytale =
    { host, ... }:
    {
      homeManager =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        };
    };
}
