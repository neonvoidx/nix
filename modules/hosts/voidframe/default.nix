{ inputs, ... }:
{
  flake.modules.nixos.voidframe =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      m = inputs.self.modules.nixos;
    in
    {
      imports = [
        # User (system-level account)
        m.neonvoid

        # Core system features
        m.boot
        m.nix-settings
        m.user-accounts
        m.locale
        m.print
        m.networking
        m.systemd
        m.overlays

        # Hardware
        m.hardware-common

        # Services
        m.pipewire
        m.desktop-services
        m.pcscd
        m.xserver
        m.udev
        m.greetd

        # Desktop
        m.fonts
        m.desktop-environment
        m.xdg
        m.desktop-programs

        # Aspects (co-located NixOS + HM concerns)
        m.zsh
        m.hyprland
        m.thunar

        # Programs
        m.system-packages
        m.noctalia

        # System configuration
        m.sops
        m.stylix

        # Hardware configuration
        (inputs.self + "/hosts/voidframe/hardware-configuration.nix")
      ];

      # Host-specific configuration from original hosts/voidframe/default.nix
      networking = {
        hostName = "voidframe";
        firewall.enable = false;
        useDHCP = lib.mkDefault true;
        wireless = {
          enable = true;
          userControlled = true;
          networks."LittyPitty".pskRaw = "654787ccc87bf9e3520e3cc82840cf1e3dd182a466e92a70d5f47ecd160501e0";
        };
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      boot = {
        loader.limine.style.interface.resolution = lib.mkDefault "2880x1920";
        initrd.luks.devices."luks-7970f8ae-ec08-42a6-a7f9-f8bbb448589f" = {
          device = "/dev/disk/by-uuid/7970f8ae-ec08-42a6-a7f9-f8bbb448589f";
        };
        kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
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

      # Home-Manager configuration
      home-manager.users.neonvoid = {
        imports = [ inputs.self.modules.homeManager.neonvoid ];
      };

      system.stateVersion = "25.11";
    };
}
