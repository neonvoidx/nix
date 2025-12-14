{
  config,
  lib,
  pkgs,
  ...
}:

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
      limine = {
        enable = true;
        secureBoot = {
          enable = true;
        };
        extraConfig = "hash_mismatch_panic: no";
        extraEntries = ''
          /Windows
              protocol: efi
              path: uuid(b50de1eb-0ac8-4d18-bb81-5f59df4c5c1c):/EFI/Microsoft/Boot/bootmgfw.efi
        '';
      };
    };
    initrd = {
      kernelModules = [ "amdgpu" ];
    };
    kernelModules = [ "amdgpu" ];
    extraModprobeConfig = ''
      options amdgpu gpu_recovery=1 ppfeaturemask=0xfffd7fff noretry=0 runpm=0 gpu_recovery=1
    '';
    kernelParams = [
      "splash"
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

  hardware = {
    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };
    amdgpu = {
      initrd.enable = lib.mkDefault true;
    };
    steam-hardware.enable = true;
  };

  services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

  environment.variables.AMD_VULKAN_ICD = "RADV";
  environment.systemPackages = with pkgs; [ amdgpu_top ];

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
