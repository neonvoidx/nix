{ den, ... }:
{
  den.aspects.base-system = {
    includes = [
      # Core system
      den.aspects.boot
      den.aspects.locale
      den.aspects.networking
      den.aspects.systemd
      den.aspects.overlays
      den.aspects.nixsettings
      den.aspects.multiverse

      # Hardware
      den.aspects.bluetooth
      den.aspects.kernel
      # Network printer settings are configured in print.nix.
      den.aspects.print
      den.aspects.udev

      # Security
      den.aspects.sops
      den.aspects.pcscd
      den.aspects.noctalia-greeter
      den.aspects.polkit

      # Services
      den.aspects.ananicy

      # System packages
      den.aspects.systempackages
    ];
  };
}
