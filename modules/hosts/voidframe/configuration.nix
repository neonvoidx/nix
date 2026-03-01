{ inputs, ... }:
{
  flake.modules.nixos.voidframe =
    { ... }:
    let
      m = inputs.self.modules.nixos;
    in
    {
      imports = [
        # User
        m.neonvoid

        # Core system
        m.boot
        m.nix-settings
        m.user-accounts
        m.locale
        m.networking
        m.systemd
        m.overlays

        # Hardware
        m.hardware-common

        # Security
        m.sops
        m.pcscd
        m.gnome-keyring

        # Services
        m.print
        m.desktop-services
        m.xserver
        m.udev
        m.greetd

        # Audio
        m.pipewire

        # Desktop
        m.fonts
        m.desktop-environment
        m.xdg
        m.desktop-programs
        m.stylix
        m.noctalia
        m.flatpak
        m.zsh

        # System packages
        m.system-packages

        # Hardware configuration
        (inputs.self + "/hosts/voidframe/hardware-configuration.nix")
      ];

      system.stateVersion = "25.11";
    };
}
