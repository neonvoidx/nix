{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./pipewire.nix
    ../common.nix
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      limine = {
        enable = true;
        # If using secure boot (for dual booting windows)
        # secureBoot = {
        #   enable = true;
        # };
        style = {
          interface = {
            resolution = lib.mkDefault "3440x1440";
          };
        };
        # If dual booting windows, add Windows to limine, use uuid
        # extraEntries = ''
        #   /Windows
        #       protocol: efi
        #       path: uuid(b50de1eb-0ac8-4d18-bb81-5f59df4c5c1c):/EFI/Microsoft/Boot/bootmgfw.efi
        # '';
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
      # AMD GPU Kernel params
      "amdgpu.gpu_recovery=1"
      "amdgpu.ppfeaturemask=0xfffd7fff"
      "amdgpu.noretry=0"
      # RDNA4 stability fixes
      "amdgpu.lockup_timeout=10000"
      "amdgpu.mes_log_enable=1"
      # Disable power management features that can cause hangs
      "amdgpu.ppfeaturemask=0xffffffff"
      "amdgpu.dcdebugmask=0x10"
      # NOTE: Disable CWSR, this really only affects multi workload
      # i.e if trying to render in blender while gaming
      # can try re-enabling later with AMD driver updates
      "amdgpu.cwsr_enable=0"
      # runpm off screws suspend/hibernate on Nix it seems
      # "amdgpu.runpm=0"
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
    # Static IP configuration
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

  # Create stable interface name based on MAC address
  systemd.network.links."10-eth0" = {
    matchConfig.MACAddress = "9c:6b:00:98:96:96";
    linkConfig.Name = "eth0";
  };

  # Only wait for ethernet during boot, wifi is disabled
  systemd.network.wait-online.anyInterface = true;

  boot.blacklistedKernelModules = [
    "mt7925e"
    "snd_hda_intel"
  ];

  hardware = {
    graphics = {
      enable = lib.mkDefault true; # Vulkan
      enable32Bit = lib.mkDefault true; # Vulkan
    };
    amdgpu = {
      initrd.enable = lib.mkDefault true; # Load amdgpu kernel module into init ram (faster)
      # Enable latest firmware for RDNA4
      opencl.enable = true;
    };
    steam-hardware.enable = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  # Update firmware for RDNA4 stability
  hardware.firmware = [ pkgs.linux-firmware ];

  services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

  # Forces RADV over AMDVLK
  environment.variables.AMD_VULKAN_ICD = "RADV";
  # Disable steam shader cache, then set cache size here
  environment.variables.MESA_SHADER_CACHE_MAX_SIZE = "32G";

  environment.systemPackages = with pkgs; [
    sbctl
    amdgpu_top
    # wowup-cf
    (blender.override { rocmSupport = true; }) # adds hardware acceleration for AMD to Blender
  ];

  system.stateVersion = "25.11";
}
