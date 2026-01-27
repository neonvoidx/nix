# NixOS configuration for the "void" host (primary workstation)
{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos;
  username = config.username;
in
{
  configurations.nixos.void = {
    hostname = "void";
    module = {
      imports = [
        # Hardware
        ../../hosts/void/hardware-configuration.nix
        ../../hosts/void/pipewire.nix
        
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
          networking.hostName = "void";
          
          # Boot configuration
          boot = {
            loader = {
              efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot";
              };
              limine = {
                enable = true;
                style.interface.resolution = lib.mkDefault "3440x1440";
              };
            };
            initrd = {
              enable = true;
              kernelModules = [ "amdgpu" ];
            };
            kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
            kernelModules = [ "amdgpu" ];
            kernelParams = [
              "splash"
              "video=DP-1:3440x1440@144"
              "video=DP-2:3440x1440@144"
              "amdgpu.gpu_recovery=1"
              "amdgpu.ppfeaturemask=0xfffd7fff"
              "amdgpu.noretry=0"
              "amdgpu.lockup_timeout=10000"
              "amdgpu.mes_log_enable=1"
              "amdgpu.ppfeaturemask=0xffffffff"
              "amdgpu.dcdebugmask=0x10"
              "amdgpu.cwsr_enable=0"
            ];
            blacklistedKernelModules = [
              "mt7925e"
              "snd_hda_intel"
            ];
            extraModulePackages = with pkgs.linuxKernel.packages.linux_xanmod_latest; [ xpadneo ];
          };
          
          # Network configuration
          networking = {
            nameservers = [
              "192.168.86.7"
              "192.168.86.8"
            ];
            wireless.enable = false;
            networkmanager.enable = false;
            interfaces.eth0 = {
              useDHCP = false;
              ipv4.addresses = [{
                address = "192.168.86.20";
                prefixLength = 24;
              }];
            };
            defaultGateway = {
              address = "192.168.86.1";
              interface = "eth0";
            };
          };
          
          # Stable interface name based on MAC address
          systemd.network.links."10-eth0" = {
            matchConfig.MACAddress = "9c:6b:00:98:96:96";
            linkConfig.Name = "eth0";
          };
          systemd.network.wait-online.anyInterface = true;
          
          # Hardware configuration
          hardware = {
            graphics = {
              enable = lib.mkDefault true;
              enable32Bit = lib.mkDefault true;
            };
            amdgpu = {
              initrd.enable = lib.mkDefault true;
              opencl.enable = true;
            };
            steam-hardware.enable = true;
            firmware = [ pkgs.linux-firmware ];
          };
          
          powerManagement.cpuFreqGovernor = "performance";
          
          services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];
          
          # Environment variables
          environment.variables = {
            AMD_VULKAN_ICD = "RADV";
            MESA_SHADER_CACHE_MAX_SIZE = "32G";
          };
          
          # Host-specific packages
          environment.systemPackages = with pkgs; [
            sbctl
            amdgpu_top
            (blender.override { rocmSupport = true; })
          ];
          
          # Home manager configuration
          home-manager = {
            backupFileExtension = "backup";
            backupCommand = "${pkgs.bash}/bin/bash -c 'rm -f \"$1.backup\" && mv \"$1\" \"$1.backup\"' -- ";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = inputs // {
              inherit username;
              hostname = "void";
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
