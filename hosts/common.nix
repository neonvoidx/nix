{ config, pkgs, lib, self, username, inputs, ... }: {
  imports = [ ];
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "sambashare"
      "video"
      "plugdev"
      "input"
      "bluetooth"
    ];
    shell = pkgs.zsh;
  };

  nixpkgs.overlays = [
    (final: prev: {
      nur = import inputs.nur {
        nurpkgs = prev;
        pkgs = prev;
      };
    })
  ];

  nix = {
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "daily";
      options = lib.mkDefault "--delete-older-than 5d";
    };
    settings = {
      # enable flakes
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      substituters = lib.mkForce [ "https://hyprland.cachix.org" ];
      trusted-users = [ "root" "neonvoid" "@wheel" ];
      allowed-users = [ "root" "neonvoid" "@wheel" ];
      # Cachix for hyprland-git
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  # System 
  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/New_York";
  hardware = { bluetooth.enable = true; };

  services = {
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
    dbus.enable = true;
    dbus.packages = with pkgs; [ bluez ];
    libinput.enable = true;
    power-profiles-daemon.enable = true;
    udev.packages = with pkgs; [
      game-devices-udev-rules
      steam-devices-udev-rules
    ];
    # Extra udev rules, like for streamdeck
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0063", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0090", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0060", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006d", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006c", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="008f", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0080", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0084", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0086", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="009a", TAG+="uaccess"
    ''; # Add any custom udev rules here
    upower.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command =
            "${pkgs.tuigreet}/bin/tuigreet -g 'The Void' --asterisks -t -r --theme text=green;time=cyan;container=gray;border=magenta;title=cyan;greet=magenta;prompt=green;input=red;action=red;button=magenta";
          user = "greeter";
        };
      };
    };
  };

  systemd = {
    settings = { Manager = { DefaultTimeoutStopSec = "10s"; }; };
    services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };

  networking.nameservers = [ "192.168.86.7" "192.168.86.8" ];
  # TODO DHCP
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp14s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp15s0.useDHCP = lib.mkDefault true;

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  hardware = {
    steam-hardware.enable = true;
    graphics.enable = true;
    graphics.extraPackages = with pkgs; [ vulkan-loader vulkan-tools ];
    cpu.amd.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  programs.hyprland = {
    enable = true;
    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    # TODO these below might go into home manager stuff, not here
    xwayland.enable = true;
    withUWSM = false;
  };

  xdg.portal = {
    enable = true;
    config = { common = { default = [ "hyprland" "gtk" ]; }; };
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      # xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  environment.variables = {
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORM = "wayland";
  };

  fonts.packages = with pkgs; [
    fira-sans
    roboto
    nerd-fonts.jetbrains-mono
    jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    material-symbols
    material-icons
  ];

  # https://search.nixos.org 
  environment.systemPackages = with pkgs; [
    # TODO flatpak curseforge
    (writeScriptBin "firefox-developer-edition" ''
      exec ${firefox-devedition}/bin/firefox-devedition "$@"
    '')
    ananicy-cpp
    ananicy-rules-cachyos
    bat
    bluetui
    bluez
    brightnessctl
    btop
    cmatrix
    fastfetch
    firefox-devedition
    gamescope
    git
    hplip
    hypridle
    hyprpolkitagent
    gcc
    libgcc
    lsd
    neovim
    nodejs_24
    pkgs.xwayland
    sbctl
    steam
    tree
    tree-sitter
    udiskie
    unzip
    usbutils
    wget
    yarn
    yazi
    zsh
  ];

  system.activationScripts.logRebuildTime = {
    text = ''
      LOG_FILE="/var/log/nixos-rebuild-log.json"
      TIMESTAMP=$(date "+%d/%m")
      GENERATION=$(readlink /nix/var/nix/profiles/system | grep -o '[0-9]\+')

      echo "{\"last_rebuild\": \"$TIMESTAMP\", \"generation\": $GENERATION}" > "$LOG_FILE"
      chmod 644 "$LOG_FILE"
    '';
  };
  system.stateVersion = "25.11";
}
