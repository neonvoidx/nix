{ ... }:
{
  flake.modules.nixos.void =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
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
        graphics = {
          enable = lib.mkDefault true;
          enable32Bit = lib.mkDefault true;
        };
        amdgpu = {
          initrd.enable = lib.mkDefault true;
          opencl.enable = true;
        };
        steam-hardware.enable = true;
        firmware = [ pkgs.linux-firmware ];
      };

      powerManagement.cpuFreqGovernor = "performance";
      services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

      environment.variables = {
        AMD_VULKAN_ICD = "RADV";
        MESA_SHADER_CACHE_MAX_SIZE = "32G";
      };

      environment.systemPackages = with pkgs; [
        sbctl
        amdgpu_top
        (blender.override { rocmSupport = true; })
      ];
    };
}
