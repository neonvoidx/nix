{ den, ... }:
{
  # void host aspect: includes all shared aspects + void-specific hardware/network
  den.aspects.void = {
    includes = [
      den.aspects.base
      den.aspects.boot
      den.aspects.nix-settings
      den.aspects.locale
      den.aspects.networking
      den.aspects.systemd
      den.aspects.overlays

      # Hardware
      den.aspects.firmware
      den.aspects.bluetooth
      den.aspects.kernel

      # Security
      den.aspects.sops
      den.aspects.pcscd
      den.aspects.gnome-keyring

      # Services
      den.aspects.print
      den.aspects.ananicy
      den.aspects.removable-media
      den.aspects.xserver
      den.aspects.udev
      den.aspects.greetd

      # Audio
      den.aspects.pipewire

      # Desktop
      den.aspects.fonts
      den.aspects.desktop-environment
      den.aspects.xdg
      den.aspects.desktop-programs
      den.aspects.stylix
      den.aspects.noctalia
      den.aspects.flatpak
      den.aspects.zsh

      # System packages
      den.aspects.system-packages

      # void-only: network drives
      den.aspects.network-drives
    ];
    # Note: system.stateVersion is set globally in modules/defaults.nix
  };
}
