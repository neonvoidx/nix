{ den, ... }:
{
  den.aspects.udev =
    { host, ... }:
    {
      nixos =
        { pkgs, lib, ... }:
        {
          services = {
            udev.packages = with pkgs; [
              game-devices-udev-rules
              steam-devices-udev-rules
              yubikey-personalization
              arduino # provides udev rules for Arduino boards (ttyUSB/ttyACM access)
              via
            ];
            # Blacklist udev rule for void
            udev.extraRules = lib.mkIf (host.hostName == "void") ''
              # Block MediaTek Wireless_Device (0e8d:0717) from binding - causes firmware timeout errors
              SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="0717", ATTR{authorized}="0"
              # Via Keyboards
              KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
            '';
          };
        };
    };
}
