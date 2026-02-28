{ inputs, ... }:
{
  flake.modules.nixos.void =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      m = inputs.self.modules.nixos;
    in
    {
      imports = [
        # User (system-level account)
        m.neonvoid

        # Core system features
        m.boot
        m.nix-settings
        m.locale
        m.networking
        m.systemd
        m.overlays

        # Hardware
        m.hardware-common

        # Services
        m.pipewire
        m.print
        m.desktop-services
        m.pcscd
        m.xserver
        m.udev
        m.greetd
        m.network-drives

        # Desktop
        m.fonts
        m.desktop-environment
        m.xdg
        m.desktop-programs

        # Aspects (co-located NixOS + HM concerns)
        m.zsh
        m.hyprland
        m.thunar

        # Programs
        m.system-packages
        m.noctalia

        # System configuration
        m.home-manager
        m.sops
        m.stylix

        # Hardware configuration
        (inputs.self + "/hosts/void/hardware-configuration.nix")
      ];

      # Host-specific boot configuration
      boot = {
        loader = {
          limine = {
            enable = true;
            secureBoot.enable = true;
            style.interface.resolution = lib.mkDefault "3440x1440";
            extraEntries = ''
              /Windows
                  protocol: efi
                  path: boot():/efi/Microsoft/Boot/bootmgfw.efi
            '';
          };
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

      # Home-Manager configuration
      home-manager.users.neonvoid = {
        imports = [ inputs.self.modules.homeManager.neonvoid ];
      };

      system.stateVersion = "25.11";
    };
}
