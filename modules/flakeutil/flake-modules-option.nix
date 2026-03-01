{ inputs, lib, ... }:
{
  # Import flake-parts' built-in modules extra, which defines flake.modules
  # with `deferredModule` type — enabling multi-file merging of the same aspect.
  imports = [ inputs.flake-parts.flakeModules.modules ];

  # Which systems to generate per-system outputs for
  config.systems = [ "x86_64-linux" ];

  options.flake.factory = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
    description = "Factory functions for creating reusable aspects";
  };
}
