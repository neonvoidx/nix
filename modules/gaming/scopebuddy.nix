{ den, inputs, ... }:
{
  den.aspects.scopebuddy.homeManager =
    { pkgs, config, ... }:
    {
      home.packages = [
        inputs.scopebuddy.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      home.file.".config/scopebuddy".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/scopebuddy";
    };
}
