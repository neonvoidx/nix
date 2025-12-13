{ inputs, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../common.nix
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      # After rebuilding with the new GRUB config:
      # sudo sbctl create-keys
      # sudo sbctl enroll-keys -m  # -m flag keeps Microsoft keys for Windows
      # sudo sbctl sign -s /boot/EFI/nixos/grubx64.efi
      # sudo sbctl sign -s /boot/vmlinuz-*
      # sudo sbctl sign -s /boot/initrd-*
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        efiInstallAsRemovable = false;
      };
      systemd-boot.enable = false;
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
    networkmanager = {
      enable = true;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.initrd.enable = true;

  environment.variables.AMD_VULKAN_ICD = "RADV";
  environment.systemPackages = with pkgs; [ linuxKernel.packages.linux_6_12.xpadneo ];

  # Install CurseForge flatpak via systemd service
  systemd.services.install-curseforge-flatpak = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      ${pkgs.flatpak}/bin/flatpak install -y flathub com.overwolf.CurseForge || true
    '';
  };

  system.stateVersion = "25.11";
}
