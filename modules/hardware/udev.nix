{ den, ... }:
{
  den.aspects.udev.nixos =
    { pkgs, ... }:
    {
      services = {
        udev.packages = with pkgs; [
          game-devices-udev-rules
          steam-devices-udev-rules
          yubikey-personalization
        ];
        udev.extraRules = ''
          # Block MediaTek Wireless_Device (0e8d:0717) from binding - causes firmware timeout errors
          SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="0717", ATTR{authorized}="0"
        '';
      };
    };
}
