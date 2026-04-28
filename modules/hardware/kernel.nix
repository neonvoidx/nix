{ den, ... }:
{
  den.aspects.kernel.nixos = {
    boot.blacklistedKernelModules = [ "hid_logitech_hidpp" ];

    # Suppress kernel messages on console/TTY
    boot.kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      # Allow GPU soft-reset on ring timeout instead of full hang
      "amdgpu.gpu_recovery=1"
    ];
  };
}
