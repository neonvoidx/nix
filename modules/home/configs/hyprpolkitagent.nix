{ ... }:
{
  flake.modules.homeManager.hyprpolkitagent =
    { ... }:
    {
      services.hyprpolkitagent = {
        enable = true;
      };
    };
}
