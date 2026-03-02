{ den, ... }:
let
  neonvoid = {
    gitName = "neonvoidx";
    gitEmail = "me@neonvoid.dev";
  };
in
{
  # example of freeform attributes w/ den:
  # isDesktop = true;
  # then inside an aspect we can use it:
  # `{ host, ... }: if host.isDesktop then ...`
  den.hosts.x86_64-linux = {
    void = {
      # main display resolution
      xRes = "3440";
      yRes = "1440";
      isGaming = true;
      # sets main resolution for greetd if multi monitor among other options
      isMultiMonitor = true;
      users.neonvoid = neonvoid;
    };
    voidframe = {
      # main display resolution
      xRes = "2880";
      yRes = "1920";
      # Controls things like battery display in noctalia etc
      isLaptop = true;
      users.neonvoid = neonvoid;
    };
  };
}
