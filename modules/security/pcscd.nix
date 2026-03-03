{ den, ... }:
{
  den.aspects.pcscd.nixos =
    { pkgs, ... }:
    {
      # Yubikey stuff
      services.pcscd.enable = true;
      environment.systemPackages = [ pkgs.pcscliteWithPolkit ];
    };
}
