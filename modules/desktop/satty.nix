{ den, ... }:
{
  den.aspects.satty.homeManager =
    { ... }:
    {
      programs.satty = {
        enable = true;
        # https://github.com/Satty-org/Satty#configuration-file
      };
    };
}
