{ den, ... }:
{
  den.aspects.halloy =
    { host, user, ... }:
    {
      homeManager = {
        programs.halloy = {
          enable = true;
          settings = {
            check_for_update_on_launch = false;
            "servers.liberachat" = {
              channels = [
                "#zig"
              ];
              nickname = user.userName;
            };
          };
        };
      };
    };
}
