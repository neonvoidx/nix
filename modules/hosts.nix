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
      users.neonvoid = neonvoid;
      home-manager.enable = true;
      ## Freeform attributes
      # main display resolution
      xRes = "3440";
      yRes = "1440";
      # sets main resolution for greetd if multi monitor among other options
      isMultiMonitor = true;
      greeting = "The Void";
    };
    voidframe = {
      users.neonvoid = neonvoid;
      home-manager.enable = true;
      ## Freeform attributes
      # main display resolution
      xRes = "2880";
      yRes = "1920";
      # Controls things like battery display in noctalia etc
      isLaptop = true;
      greeting = "Void Frame";
    };
  };
}
