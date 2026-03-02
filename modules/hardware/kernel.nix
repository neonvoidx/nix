{ ... }:
{
  den.aspects.kernel.nixos = {
    # Suppress kernel messages on console/TTY
    boot.kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];
  };
}
