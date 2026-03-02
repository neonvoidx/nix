{ den, ... }:
{
  den.aspects.hyprpolkitagent.homeManager =
    { ... }:
    {
      services.hyprpolkitagent = {
        enable = true;
      };
    };
}
