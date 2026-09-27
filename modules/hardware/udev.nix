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
              meletrix-udev-rules
              qmk
              qmk-udev-rules
              qmk_hid
              via
              vial
            ];
            # Device-specific udev rules for void
            udev.extraRules = lib.mkIf (host.hostName == "void") ''
              # Via Keyboards
              KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
              # Sat75
              KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", ATTRS{idVendor}=="ca04", ATTRS{idProduct}=="0011", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
              # Zoom75 Tiga
              KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", ATTRS{idVendor}=="1ea7", ATTRS{idProduct}=="cedd", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
            '';
          };
        };
    };
}
