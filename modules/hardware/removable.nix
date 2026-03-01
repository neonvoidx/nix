{ ... }:
{
  flake.modules.nixos.removable-media =
    { pkgs, ... }:
    {
      services = {
        udisks2.enable = true;
      };
    };
}
