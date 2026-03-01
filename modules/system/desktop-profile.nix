{ inputs, ... }:
{
  # Shared base profile for all desktop NixOS hosts.
  # Aggregates leaf aspects so host configuration.nix stays short.
  flake.modules.nixos.desktop-base = {
    imports = with inputs.self.modules.nixos; [
      # Core system
      boot
      nix-settings
      user-accounts
      locale
      networking
      systemd
      overlays

      # Hardware
      firmware
      bluetooth
      kernel

      # Security
      sops
      pcscd
      gnome-keyring

      # Services
      print
      desktop-services
      xserver
      udev
      greetd

      # Audio
      pipewire

      # Desktop
      fonts
      desktop-environment
      xdg
      desktop-programs
      stylix
      noctalia
      flatpak
      zsh

      # System packages
      system-packages
    ];
  };
}
