{ ... }:
{
  flake.modules.homeManager.bat =
    { ... }:
    {
      programs.bat = {
        enable = true;
      };

      programs.zsh.shellAliases.bat = "bat";
    };
}
