{ ... }:
{
  flake.modules.homeManager.just =
    { config, ... }:
    {
      home.file.".config/just/justfile" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/justfile";
      };
    };
}
