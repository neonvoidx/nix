{ ... }:
{
  flake.modules.nixos.hardware-common =
    { config, lib, ... }:
    {
      hardware = {
        enableRedistributableFirmware = true;
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        bluetooth = {
          enable = true;
          network = {
            General = {
              DisableSecurity = true;
            };
            LE = {
              MinConnectionInterval = 7;
              MaxConnectionInterval = 9;
              ConnectionLatency = 0;
            };
          };
        };
      };
      
      # Suppress kernel messages on console/TTY
      boot.kernelParams = [ "quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3" ];
    };
}
