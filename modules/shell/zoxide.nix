{ den, ... }:
{
  den.aspects.zoxide.homeManager =
    { ... }:
    {
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
        options = [
          "--cmd"
          "cd"
        ];
      };
    };
}
