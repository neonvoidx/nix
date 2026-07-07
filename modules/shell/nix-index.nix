{ den, ... }:
{
  den.aspects.nix-index.homeManager =
    { ... }:
    {
      programs.nix-index = {
        enable = true;
        enableZshIntegration = true;
      };
    };
}
