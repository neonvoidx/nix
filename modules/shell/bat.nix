{ den, ... }:
{
  den.aspects.bat.homeManager =
    { ... }:
    {
      programs.bat = {
        enable = true;
      };

      programs.zsh.shellAliases.cat = "bat";
    };
}
