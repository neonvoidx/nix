{ den, inputs, ... }:
{
  den.aspects.void = {
    includes = [
      # Core system
      den.aspects.boot
      den.aspects.locale
      den.aspects.networking
      den.aspects.systemd
      den.aspects."user-accounts"
      den.aspects.overlays
      den.aspects."nix-settings"

      # Hardware
      den.aspects.firmware
      den.aspects.bluetooth
      den.aspects.kernel
      den.aspects.streamcontroller
      den.aspects.print
      den.aspects."removable-media"
      den.aspects.udev

      # Security
      den.aspects.sops
      den.aspects.pcscd
      den.aspects.greetd

      # Services
      den.aspects.ananicy
      den.aspects."network-drives"

      # System packages
      den.aspects."system-packages"
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
