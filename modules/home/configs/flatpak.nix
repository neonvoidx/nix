{ ... }:
{
  flake.modules.homeManager.flatpak =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.flatpak ];
    };
}
