{ inputs, ... }:
{
  den.aspects.voidframe.nixos =
    { pkgs, lib, ... }:
    {
      imports = [ (inputs.self + "/hosts/voidframe/hardware-configuration.nix") ];

      boot = {
        loader.limine.style.interface.resolution = lib.mkDefault "2880x1920";
        initrd.luks.devices."luks-7970f8ae-ec08-42a6-a7f9-f8bbb448589f" = {
          device = "/dev/disk/by-uuid/7970f8ae-ec08-42a6-a7f9-f8bbb448589f";
        };
        kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # Prevent rfkill from softblocking bluetooth and wifi
      systemd.services.rfkill-unblock = {
        description = "Unblock rfkill devices";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        script = ''
          ${pkgs.util-linux}/bin/rfkill unblock all
        '';
      };
    };
}
