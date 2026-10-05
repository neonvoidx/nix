{ den, ... }:
{
  den.aspects.udev = {
    nixos =
      { pkgs, ... }:
      {
        services = {
          udev.packages = with pkgs; [
            game-devices-udev-rules
            steam-devices-udev-rules
            yubikey-personalization
            arduino # provides udev rules for Arduino boards (ttyUSB/ttyACM access)
            meletrix-udev-rules
            qmk
            qmk-udev-rules
            qmk_hid
            via
            vial
          ];
        };
      };
  };
}
