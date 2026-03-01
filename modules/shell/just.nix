{ ... }:
{
  flake.modules.homeManager.just =
    { pkgs, config, ... }:
    {
      home.packages = [ pkgs.just ];
      home.file.".config/just/justfile" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/justfile";
      };
    };
}
