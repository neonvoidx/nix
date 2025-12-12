{ ... }:
{
  imports = [
    # System configuration
    ../modules/system/boot.nix
    ../modules/system/nix.nix
    ../modules/system/users.nix
    # ../modules/system/overlays.nix
    ../modules/system/systemd.nix
    ../modules/system/locale.nix
    ../modules/system/networking.nix

    # Hardware configuration
    ../modules/hardware/default.nix

    # Services
    ../modules/services/pipewire.nix
    ../modules/services/desktop.nix
    ../modules/services/xserver.nix
    ../modules/services/udev.nix
    ../modules/services/greetd.nix
    ../modules/services/network-drives.nix

    # Desktop environment
    ../modules/desktop/fonts.nix
    ../modules/desktop/environment.nix
    ../modules/desktop/xdg.nix
    ../modules/desktop/programs.nix

    # System packages
    ../modules/packages/system.nix
  ];

  system.stateVersion = "25.11";
}
