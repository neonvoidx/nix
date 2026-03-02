{ den, ... }:
{
  den.aspects.hyprshot.homeManager =
    { ... }:
    {
      programs.hyprshot = {
        enable = true;
        saveLocation = "$HOME/Screenshots";
      };
    };
}
