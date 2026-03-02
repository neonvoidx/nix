{ den, ... }:
{
  den.aspects.flatpak = {
    nixos =
      { ... }:
      {
        services.flatpak.enable = true;
      };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.flatpak ];
      };
  };
}
