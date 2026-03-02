{ ... }:
{
  den.aspects.firmware.nixos =
    { lib, config, ... }:
    {
      hardware = {
        enableRedistributableFirmware = true;
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
}
