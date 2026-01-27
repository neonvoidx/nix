{ config, lib, ... }:
{
  flake.modules.nixos.hardware = { config, lib, ... }: {
    hardware = {
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
  };
}
