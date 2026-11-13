{ den, ... }:
{
  den.aspects.kernel.nixos =
    { pkgs, ... }:
    {
      boot = {
        kernelPackages = pkgs.linuxPackages_zen;
        blacklistedKernelModules = [ "hid_logitech_hidpp" ];
        kernelParams = [
          "quiet"
          "loglevel=3"
          "systemd.show_status=auto"
          "rd.udev.log_level=3"
          # Allow GPU soft-reset on ring timeout instead of full hang
          "amdgpu.gpu_recovery=1"
        ];
      };
    };
}
