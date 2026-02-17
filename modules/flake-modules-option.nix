{ lib, ... }:
{
  # Define flake.modules option to support dendritic pattern
  options.flake.modules = lib.mkOption {
    type = lib.types.submodule {
      freeformType = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.raw);
    };
    default = { };
    description = "Dendritic aspect modules organized by class (nixos, darwin, homeManager)";
  };
}
