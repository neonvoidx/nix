{ inputs, ... }:
{
  den.aspects.nvim.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
