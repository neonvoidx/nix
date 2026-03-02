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
      xRes = "3440";
      yRes = "1440";
      isGaming = true;
      isMultiMonitor = true;
      users.neonvoid = neonvoid;
    };
    voidframe = {
      xRes = "2880";
      yRes = "1920";
      isLaptop = true;
      users.neonvoid = neonvoid;
    };
  };
}
