{ ... }:
{
  flake.modules.nixos.pcscd =
    { pkgs, ... }:
    {
      services.pcscd.enable = true;
      environment.systemPackages = [ pkgs.pcscliteWithPolkit ];
    };
}
