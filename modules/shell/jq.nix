{ den, ... }:
{
  den.aspects.jq.homeManager =
    { ... }:
    {
      programs.jq = {
        enable = true;
      };
    };
}
