{ den, inputs, ... }:
{
  den.aspects.voidframe = {
    includes = [
      # Core system
      den.aspects.boot
      den.aspects.locale
      den.aspects.networking
      den.aspects.systemd
      den.aspects.users
      den.aspects.overlays
      den.aspects.nixsettings
      den.aspects.multiverse

      # Hardware
      den.aspects.bluetooth
      den.aspects.kernel
      # Network printer stuff, specific to my network
      # If you want to setup network printer be sure to edit print.nix
      den.aspects.print
      den.aspects.udev

      # Security
      den.aspects.sops
      den.aspects.pcscd
      # den.aspects.ly
      den.aspects.noctalia-greeter
      den.aspects.polkit

      # Services
      den.aspects.ananicy

      # System packages
      den.aspects.systempackages
    ];

    nixos =
      { pkgs, lib, ... }:
      {
        imports = [ (inputs.self + "/hosts/voidframe/hardware-configuration.nix") ];

        boot = {
          loader.limine.style.interface.resolution = lib.mkDefault "2880x1920";
          initrd.luks.devices."luks-7970f8ae-ec08-42a6-a7f9-f8bbb448589f" = {
            device = "/dev/disk/by-uuid/7970f8ae-ec08-42a6-a7f9-f8bbb448589f";
          };
          kernelPackages = pkgs.linuxPackages_zen;
        };

        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };

        systemd.services.rfkill-unblock = {
          description = "Unblock rfkill devices";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          script = ''
            ${pkgs.util-linux}/bin/rfkill unblock all
          '';
        };

        networking = {
          firewall.enable = false;
          useDHCP = true;
          wireless = {
            enable = true;
            userControlled = true;
            networks."LittyPitty".pskRaw = "654787ccc87bf9e3520e3cc82840cf1e3dd182a466e92a70d5f47ecd160501e0";
          };
        };
      };
  };
}
