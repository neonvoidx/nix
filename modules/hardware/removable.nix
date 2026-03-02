{ ... }:
{
  den.aspects.removable-media.nixos =
    { pkgs, ... }:
    {
      services = {
        udisks2.enable = true;
      };
    };
}
