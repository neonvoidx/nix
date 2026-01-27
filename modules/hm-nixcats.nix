{ config, ... }:
{
  flake.modules.homeManager.nixcats = {
    pkgs,
    inputs,
    config,
    ...
  }:
    let
      nixCatsConfig = import inputs.nvim-config { inherit pkgs inputs; };
      inherit (inputs.nixCats) utils;

      nixCatsNvim =
        utils.baseBuilder nixCatsConfig.luaPath
          {
            inherit (nixCatsConfig) dependencyOverlays extra_pkg_config;
            nixpkgs = inputs.nixpkgs;
            system = pkgs.stdenv.hostPlatform.system;
          }
          nixCatsConfig.categoryDefinitions
          nixCatsConfig.packageDefinitions
          nixCatsConfig.defaultPackageName;
    in
    {
      home.packages = [ nixCatsNvim ];
    };
}
