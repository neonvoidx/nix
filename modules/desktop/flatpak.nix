{ ... }:
{
  den.aspects.flatpak.nixos = { ... }: {
    services.flatpak.enable = true;
  };

  den.aspects.flatpak.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.flatpak ];
    };
}
