{ inputs, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ../common.nix ];

  boot = {
    loader = {
      # TODO GRUB and dual boot and secure boot
      #  efi = {
      #    canTouchEfiVariables = true;
      #    efiSysMountPoint = "/boot/efi";
      #  };
      #  grub = {
      #    efiSupport = true;
      #    device = "nodev";
      #    enable=true;
      #    useOSProber = true;
      #  };
      #};
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    # TODO how to get cachyos kernel
    # kernelPackages = pkgs.linuxPackages_cachyos;
    kernelParams = [
      "splash"
      "amdgpu_recovery=1"
      "amdgpu.ppfeaturemask=0xfffd7fff"
      "amdgpu.noretry=0"
      "amdgpu.runpm=0"
      "amdgpu.gpu_recovery=1"
      "video=DP-1:3440x1440@144"
      "video=DP-2:3440x1440@144"
      "video=HDMI-A-1:2560x1440@144"
    ];
  };

  networking = {
    hostName = "void";
    firewall.enable = false;
    networkmanager = { enable = true; };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.initrd.enable = true;

  environment.variables.AMD_VULKAN_ICD = "RADV";
  environment.systemPackages = with pkgs;
    [ linuxKernel.packages.linux_6_12.xpadneo ];

  system.stateVersion = "25.11";
}

