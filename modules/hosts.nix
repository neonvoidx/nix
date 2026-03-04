{ den, ... }:
let
  neonvoid = {
    gitName = "neonvoidx";
    gitEmail = "me@neonvoid.dev";
  };
  timezone = "America/New_York";
in
{
  # example of freeform attributes w/ den:
  # isDesktop = true;
  # then inside an aspect we can use it:
  # `{ host, ... }: if host.isDesktop then ...`
  den.hosts.x86_64-linux = {
    void = {
      users.neonvoid = neonvoid;
      ## Freeform attributes
      # main display resolution
      xRes = "3440";
      yRes = "1440";
      # sets main resolution for greetd if multi monitor among other options
      isMultiMonitor = true;
      # Dedicated GPU Device id
      # lspci | grep -i 'vga\|3d\|display'
      # prepend `0000:` to the device id
      # this is used for setting dedicated gpu for things like MangoHud
      gpuPciDev = "0000:03:00.0"; # AMD RX 9070 XT
      greeting = "The Void";
      timezone = timezone;
    };
    voidframe = {
      users.neonvoid = neonvoid;
      ## Freeform attributes
      # main display resolution
      xRes = "2880";
      yRes = "1920";
      # Controls things like battery display in noctalia etc
      isLaptop = true;
      greeting = "Void Frame";
      timezone = timezone;
    };
  };
}
