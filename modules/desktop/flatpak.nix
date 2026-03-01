{ ... }:
{
  flake.modules.nixos.flatpak = { ... }: {
    services.flatpak.enable = true;
  };

  flake.modules.homeManager.flatpak =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.flatpak ];
    };
}
