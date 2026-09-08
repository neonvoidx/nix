{ den, ... }:
{
  den.aspects.fzf.homeManager =
    { ... }:
    {
      programs.fzf = {
        enable = true;
        tmux.enableShellIntegration = true;
      };
    };
}
