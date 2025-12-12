{ config, lib, ... }:
{
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth = {
      enable = true;
      network = {
        General = {
          # Security disabled for compatibility with certain devices
          # Consider re-enabling with device-specific exceptions if needed
          DisableSecurity = true;
        };
      };
    };
  };
}
