{ den, ... }:
{
  den.aspects.payrespects.homeManager =
    { ... }:
    {
      programs.pay-respects = {
        enable = true;
        enableZshIntegration = true;
      };
    };
}
