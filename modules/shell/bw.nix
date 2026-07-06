{ den, ... }:
{
  den.aspects.bw.homeManager =
    { user, ... }:
    {
      programs.rbw = {
        enable = true;
        settings = {
          email = user.gitEmail;
        };
      };
    };
}
