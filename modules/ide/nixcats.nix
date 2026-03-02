{ ... }:
{
  den.aspects.nixcats.homeManager =
    { pkgs, inputs, ... }:
    let
      nixCatsConfig = import inputs.nvim-config { inherit pkgs inputs; };
      inherit (inputs.nixCats) utils;

      # Build nixCats neovim package
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
      # Install nixCats neovim
      home.packages = [ nixCatsNvim ];
    };
}
