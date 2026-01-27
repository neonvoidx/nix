{ config, inputs, lib, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.voidframe.module = { pkgs, config, lib, ... }: {
    imports = [
      nixos.boot
      nixos.nix-settings
      nixos.users
      nixos.locale
      nixos.networking
      nixos.overlays
      nixos.systemd
      nixos.hardware
      nixos.pipewire
      nixos.desktop-services
      nixos.pcscd
      nixos.xserver
      nixos.udev
      nixos.greetd
      nixos.network-drives
      nixos.fonts
      nixos.environment
      nixos.xdg
      nixos.programs
      nixos.system-packages
      nixos.sops
      nixos.stylix
      nixos.hyprshutdown
      nixos.noctalia
      nixos.scopebuddy
      ./hosts/voidframe/hardware-configuration.nix
      inputs.spicetify-nix.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
    ];

    _module.args = {
      username = "neonvoid";
      hostname = "voidframe";
      inherit inputs;
    };

    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [ inputs.nur.overlays.default ];
    nix.extraOptions = ''
      connect-timeout = 10
      stalled-download-timeout = 100
      download-attempts = 5
    '';

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
      loader = {
        limine = {
          style = {
            interface = {
              resolution = lib.mkDefault "2880x1920";
            };
          };
        };
      };

      initrd.luks.devices."luks-7970f8ae-ec08-42a6-a7f9-f8bbb448589f" = {
        device = "/dev/disk/by-uuid/7970f8ae-ec08-42a6-a7f9-f8bbb448589f";
      };
      kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    };

    systemd.services.rfkill-unblock = {
      description = "Unblock rfkill devices";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.util-linux}/bin/rfkill unblock all";
      };
    };

    home-manager.backupFileExtension = "backup";
    home-manager.backupCommand = "${pkgs.bash}/bin/bash -c 'rm -f \"$1.backup\" && mv \"$1\" \"$1.backup\"' -- ";
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.extraSpecialArgs = inputs // {
      username = "neonvoid";
      hostname = "voidframe";
      inherit (inputs) nix-index-database nix-versions;
      nixvimOptions = inputs.nixvim.packages.x86_64-linux.options-json + /share/doc/nixos/options.json;
    };
    home-manager.users.neonvoid = import ./home/neonvoid/home.nix;

    system.stateVersion = "25.11";
  };
}
