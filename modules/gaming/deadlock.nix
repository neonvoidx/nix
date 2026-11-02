{ den, inputs, ... }:
{
  den.aspects.deadlock.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.deadlock-mod-manager.packages.${pkgs.stdenv.hostPlatform.system}.nightly
      ];
    };
}
