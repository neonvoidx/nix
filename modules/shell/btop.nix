{ den, ... }:
{
  den.aspects.btop.homeManager =
    { config, ... }:
    {
      programs.btop = {
        enable = true;
      };
      programs.zsh.shellAliases = {
        top = "btop";
        htop = "btop";
      };
    };
}
