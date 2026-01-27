{ config, inputs, lib, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.void.module = { pkgs, config, lib, ... }: {
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
      ./hosts/void/hardware-configuration.nix
      ./hosts/void/pipewire.nix
      inputs.spicetify-nix.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
    ];

    _module.args = {
      username = "neonvoid";
      hostname = "void";
      inherit inputs;
    };

    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [ inputs.nur.overlays.default ];
    nix.extraOptions = ''
      connect-timeout = 10
      stalled-download-timeout = 100
      download-attempts = 5
    '';

    boot = {
      loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        limine = {
          enable = true;
          style = {
            interface = {
              resolution = lib.mkDefault "3440x1440";
            };
          };
        };
      };
      initrd = {
        enable = true;
        kernelModules = [ "amdgpu" ];
      };
      kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
      extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
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
    };

    networking = {
      nameservers = [
        "192.168.86.7"
        "192.168.86.8"
      ];
      wireless = {
        enable = false;
      };
      hostName = "void";
      networkmanager = {
        enable = false;
      };
      interfaces.eth0 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.86.20";
            prefixLength = 24;
          }
        ];
      };
      defaultGateway = {
        address = "192.168.86.1";
        interface = "eth0";
      };
    };

    systemd.network.links."10-eth0" = {
      matchConfig.MACAddress = "9c:6b:00:98:96:96";
      linkConfig.Name = "eth0";
    };

    systemd.network.wait-online.anyInterface = true;

    boot.blacklistedKernelModules = [
      "mt7925e"
      "snd_hda_intel"
    ];

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
    };

    powerManagement.cpuFreqGovernor = "performance";

    hardware.firmware = [ pkgs.linux-firmware ];

    services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

    environment.variables.AMD_VULKAN_ICD = "RADV";
    environment.variables.MESA_SHADER_CACHE_MAX_SIZE = "32G";

    environment.systemPackages = with pkgs; [
      sbctl
      amdgpu_top
      (blender.override { rocmSupport = true; })
    ];

    home-manager.backupFileExtension = "backup";
    home-manager.backupCommand = "${pkgs.bash}/bin/bash -c 'rm -f \"$1.backup\" && mv \"$1\" \"$1.backup\"' -- ";
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.extraSpecialArgs = inputs // {
      username = "neonvoid";
      hostname = "void";
      inherit (inputs) nix-index-database nix-versions;
      nixvimOptions = inputs.nixvim.packages.x86_64-linux.options-json + /share/doc/nixos/options.json;
    };
    home-manager.users.neonvoid = import ./home/neonvoid/home.nix;

    system.stateVersion = "25.11";
  };
}
