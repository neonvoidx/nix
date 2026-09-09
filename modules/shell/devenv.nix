{ den, ... }:
{
  den.aspects.devenv.homeManager =
    { ... }:
    {
      programs.devenv = {
        # TODO when 2.3 drops
        # tui.statusline.enabled: false
        enable = true;
        enableZshIntegration = true;
      };
    };
}
