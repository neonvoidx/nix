{ config, lib, ... }:
{
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth = {
      enable = true;
      network = {
        General = {
          DisableSecurity = true;
        };
      };
    };
  };
}
