{ den, ... }:
{
  den.aspects.clipboard.homeManager =
    { ... }:
    {
      services.cliphist = {
        enable = true;
      };
      services.wl-clip-persist = {
        enable = true;
      };
    };
}
