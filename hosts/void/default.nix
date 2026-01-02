{
  lib,
  pkgs,
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
      # Disable wifi module manually
      # TODO do this a better way?
      # i have wireless disabled below under networking
      # availableKernelModules = [ "vfio-pci" ];
      # preDeviceCommands = ''
      #   echo "vfio-pci" > /sys/bus/pci/devices/0000:0b:00.0/driver_override
      #   modprobe -i vfio-pci
      # '';
    };
    kernelModules = [ "amdgpu" ];
    kernelParams = [
      "splash"
      "video=DP-1:3440x1440@144"
      "video=DP-2:3440x1440@144"
      "video=HDMI-A-1:2560x1440@144"
      # AMD GPU Kernel params
      "amdgpu.gpu_recovery=1"
      "amdgpu.ppfeaturemask=0xfffd7fff"
      "amdgpu.noretry=0"
      # runpm off fucks up hibernate/suspend
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
  };

  hardware = {
    graphics = {
      enable = lib.mkDefault true; # Vulkan
      enable32Bit = lib.mkDefault true; # Vulkan
    };
    amdgpu = {
      initrd.enable = lib.mkDefault true; # Load amdgpu kernel module into init ram (faster)
    };
    steam-hardware.enable = true;
  };

  services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

  # Forces RADV over AMDVLK
  environment.variables.AMD_VULKAN_ICD = "RADV";
  # Disable steam shader cache, then set cache size here
  environment.variables.MESA_SHADER_CACHE_MAX_SIZE = "32G";

  environment.systemPackages = with pkgs; [
    sbctl
    amdgpu_top
    wowup-cf
    blender-hip # adds hardware acceleration for AMD to Blender
  ];

  system.stateVersion = "25.11";
}
