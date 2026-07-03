{ den, ... }:
{
  den.aspects.jj =
    { user, ... }:
    {
      homeManager =
        { ... }:
        {
          programs.jujutsu = {
            enable = true;
            settings = {
              user = {
                name = user.gitName;
                email = user.gitEmail;
              };
              ui = {
                default-command = "log";
              };
            };
          };
        };
    };
}
