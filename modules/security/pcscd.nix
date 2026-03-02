{ den, ... }:
{
  den.aspects.pcscd.nixos =
    { pkgs, ... }:
    {
      services.pcscd.enable = true;
      environment.systemPackages = [ pkgs.pcscliteWithPolkit ];
    };
}
