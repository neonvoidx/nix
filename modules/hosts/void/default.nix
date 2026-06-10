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

      # Network printer stuff, specific to my network
      # If you want to setup network printer be sure to edit print.nix
      den.aspects.print
      den.aspects.udev

      # Security
      den.aspects.sops
      den.aspects.pcscd
      den.aspects.ly
      # den.aspects.regreet

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
          kernelPackages = pkgs.linuxPackages_zen;
          kernelModules = [
            "amdgpu"
            "ntsync"
          ];
          kernelParams = [
            "splash"
            "video=DP-1:3440x1440@144"
            "video=DP-2:3440x1440@144"
            "amdgpu.gpu_recovery=1"
            "amdgpu.ppfeaturemask=0xfffd7fff"
            "amdgpu.noretry=0"
            "amdgpu.lockup_timeout=10000"
            # "amdgpu.mes_log_enable=1"
            # Workaround for RX 9070 XT (RDNA4) SMU firmware version mismatch (driver 0x2e vs fw 0x33)
            # Disables dynamic power management to prevent SMU hang-on-transition until kernel catches up.
            # Remove when: journalctl -b -k | grep "SMU driver if version" shows driver and fw versions match (both 0x33).
            # That will happen when nixpkgs flake gets kernel 6.20+.
            # "amdgpu.dpm=0"
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
          xone.enable = true;
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
          nameservers = [
            # "1.1.1.1"
            # "1.0.0.1"
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
