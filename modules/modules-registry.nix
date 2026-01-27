{ lib, ... }:
{
  options.flake.modules.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = {};
  };

  options.flake.modules.homeManager = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = {};
  };
}
