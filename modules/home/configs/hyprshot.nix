{ ... }:
{
  flake.modules.homeManager.hyprshot =
    { ... }:
    {
      programs.hyprshot = {
        enable = true;
        saveLocation = "$HOME/Screenshots";
      };
    };
}
