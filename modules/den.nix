{ inputs, ... }:
{
  imports = [
    (inputs.den.flakeModules.dendritic or { })
  ];
}
