{ den, ... }:
{
  den.aspects.usb = {
    nixos =
      { pkgs, ... }:
      {
        services = {
          udisks2.enable = true;
        };
      };
    homeManager = {
      services = {
        udiskie = {
          enable = true;
          automount = true;
          tray = "auto";
        };
      };
    };
  };
}
