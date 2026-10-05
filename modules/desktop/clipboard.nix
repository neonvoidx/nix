{ den, ... }:
{
  den.aspects.clipboard.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.wl-clipboard ];

      services.cliphist = {
        enable = true;
      };
      services.wl-clip-persist = {
        enable = true;
      };
    };
}
