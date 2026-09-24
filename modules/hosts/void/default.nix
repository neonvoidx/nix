{ den, inputs, ... }:
{
  den.aspects.void = { host, ... }: {
    includes = [
      den.aspects.base-system
      den.aspects.wireguard
      # Network mounts are configured in network-drives.nix.
      den.aspects.networkdrives
      den.aspects.gaming
    ];

    nixos =
      {
        lib,
        pkgs,
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
        };

        powerManagement.cpuFreqGovernor = "performance";

        environment.variables = {
          AMD_VULKAN_ICD = "RADV";
          MESA_SHADER_CACHE_MAX_SIZE = "32G";
        };

        environment.systemPackages = with pkgs; [
          sbctl
          amdgpu_top
          pkgsRocm.blender
        ];

        networking = {
          nameservers = host.network.dns;
          wireless.enable = false;
          networkmanager.enable = false;
          interfaces.${host.network.interface} = {
            useDHCP = false;
            ipv4.addresses = [
              {
                address = host.network.ip;
                prefixLength = host.network.prefixLength;
              }
            ];
          };
          defaultGateway = {
            address = host.network.gateway;
            interface = host.network.interface;
          };
        };

        systemd.network = {
          links."10-${host.network.interface}" = {
            matchConfig.MACAddress = host.network.mac;
            linkConfig.Name = host.network.interface;
          };
          wait-online.anyInterface = true;
        };
      };
  };
}
