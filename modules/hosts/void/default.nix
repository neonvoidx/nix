{ den, inputs, ... }:
{
  den.aspects.void = {
    includes = [
      # Core system
      den.aspects.boot
      den.aspects.locale
      den.aspects.networking
      den.aspects.systemd
      den.aspects.users
      den.aspects.overlays
      den.aspects.nixsettings

      # Hardware
      den.aspects.bluetooth
      den.aspects.kernel
      den.aspects.streamcontroller

      # Network printer stuff, specific to my network
      # If you want to setup network printer be sure to edit print.nix
      den.aspects.print
      den.aspects.usb
      den.aspects.udev

      # Security
      den.aspects.sops
      den.aspects.pcscd
      den.aspects.greetd

      # Gaming
      ## WoW Addon manager
      den.aspects.curseforge
      ## Hytale
      den.aspects.hytale
      ## Deadlock mod manager
      den.aspects.deadlock

      # NOTE: If you want microphone noise suppression, will need to edit noisetorch.nix to update device ids and hostname
      den.aspects.noisetorch

      # Services
      den.aspects.ananicy
      # WARNING: Specific to my network drives, don't use this unless you want to change network-drives.nix
      # for your own network mount drives
      den.aspects.networkdrives

      # System packages
      den.aspects.systempackages
    ];

    nixos =
      {
        lib,
        pkgs,
        config,
        ...
      }:
      {
        imports = [ (inputs.self + "/hosts/void/hardware-configuration.nix") ];

        boot = {
          loader.limine = {
            enable = true;
            secureBoot.enable = true;
            style.interface.resolution = lib.mkDefault "3440x1440";
            extraEntries = ''
              /Windows
                  protocol: efi
                  path: boot():/efi/Microsoft/Boot/bootmgfw.efi
            '';
          };
          initrd = {
            enable = true;
            kernelModules = [ "amdgpu" ];
          };
          kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
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
            # Specifically for high parallel workloads, fixes Hytale
            "amdgpu.cwsr_enable=0"
          ];
          blacklistedKernelModules = [
            "mt7925e"
            "snd_hda_intel"
          ];
        };

        hardware = {
          amdgpu = {
            initrd.enable = lib.mkDefault true;
            opencl.enable = true;
          };
          firmware = [ pkgs.linux-firmware ];
          graphics = {
            enable = lib.mkDefault true;
            enable32Bit = lib.mkDefault true;
          };
          steam-hardware.enable = true;
        };

        powerManagement.cpuFreqGovernor = "performance";

        environment.variables = {
          AMD_VULKAN_ICD = "RADV";
          MESA_SHADER_CACHE_MAX_SIZE = "32G";
        };

        environment.systemPackages = with pkgs; [
          sbctl
          amdgpu_top
          (blender.override { rocmSupport = true; })
        ];

        networking = {
          hostName = "void";
          nameservers = [
            "192.168.86.7"
            "192.168.86.8"
          ];
          wireless.enable = false;
          networkmanager.enable = false;
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

        systemd.network = {
          links."10-eth0" = {
            matchConfig.MACAddress = "9c:6b:00:98:96:96";
            linkConfig.Name = "eth0";
          };
          wait-online.anyInterface = true;
        };
      };
  };
}
