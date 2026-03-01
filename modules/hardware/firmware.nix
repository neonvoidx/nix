{ ... }:
{
  flake.modules.nixos.firmware =
    { lib, config, ... }:
    {
      hardware = {
        enableRedistributableFirmware = true;
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
}
