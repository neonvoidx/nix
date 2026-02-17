{ ... }:
{
  flake.modules.homeManager.clipboard =
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
