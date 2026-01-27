# Import flake-parts.modules for deferredModule support
{ inputs, ... }:
{
  imports = [
    # https://flake.parts/options/flake-parts-modules.html
    inputs.flake-parts.flakeModules.modules
  ];
}
