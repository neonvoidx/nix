# NixOS configuration for the "voidframe" host (secondary system/laptop)
{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos;
  username = config.username;
in
{
  configurations.nixos.voidframe = {
    hostname = "voidframe";
    module = {
      imports = [
        # Hardware
        ../../hosts/voidframe/hardware-configuration.nix
        
        # Base modules
        nixos.nixpkgs-config
        nixos.nix-settings
        nixos.system
        nixos.hardware
        nixos.desktop
        nixos.services
        
        # Specific programs
        inputs.spicetify-nix.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        inputs.stylix.nixosModules.stylix
        
        # Home manager integration
        inputs.home-manager.nixosModules.home-manager
        
        # Host-specific configuration
        ({ pkgs, lib, ... }: {
          networking.hostName = "voidframe";
          
          # Network configuration
          networking = {
            firewall.enable = false;
            useDHCP = lib.mkDefault true;
            wireless = {
              enable = true;
              userControlled = true;
              networks."LittyPitty".pskRaw = "654787ccc87bf9e3520e3cc82840cf1e3dd182a466e92a70d5f47ecd160501e0";
            };
          };
          
          # Graphics
          hardware.graphics = {
            enable = true;
            enable32Bit = true;
          };
          
          # Boot configuration
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
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.util-linux}/bin/rfkill unblock all";
            };
          };
          
          # Home manager configuration
          home-manager = {
            backupFileExtension = "backup";
            backupCommand = "${pkgs.bash}/bin/bash -c 'rm -f \"$1.backup\" && mv \"$1\" \"$1.backup\"' -- ";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = inputs // {
              inherit username;
              hostname = "voidframe";
              nix-index-database = inputs.nix-index-database;
              nix-versions = inputs.nix-versions;
              nixvimOptions = inputs.nixvim.packages.x86_64-linux.options-json + /share/doc/nixos/options.json;
            };
            users.${username} = nixos.home-neonvoid;
          };
          
          system.stateVersion = "25.11";
        })
      ];
    };
  };
}
