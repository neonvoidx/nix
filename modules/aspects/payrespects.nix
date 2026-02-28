{ ... }:
{
  flake.modules.homeManager.payrespects =
    { ... }:
    {
      programs.pay-respects = {
        enable = true;
        enableZshIntegration = true;
      };
    };
}
