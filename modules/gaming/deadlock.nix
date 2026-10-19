{ den, inputs, ... }:
{
  den.aspects.deadlock.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.grimoire.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
