{ pkgs, lib, username, inputs, ... }: {
  imports = [ ../modules/fonts.nix ];
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" "sambashare" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };
  nixpkgs.config.allowUnfree = true;
  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Cachix for hyprland-git
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys =
      [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

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
    libinput.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  networking.nameservers = [ "192.168.86.7" "192.168.86.8" ];

  programs.zsh.enable = true;
  programs.steam.enable = true;
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

  environment.pathsToLink = [ "/share/zsh" ];

  # https://search.nixos.org 
  environment.systemPackages = with pkgs; [
    # TODO FONTS
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
    git
    hplip
    hypridle
    hyprpolkitagent
    lsd
    neovim
    nodejs_24
    sbctl
    steam
    tealdeer
    tree
    tree-sitter
    udiskie
    unzip
    wget
    yazi
    zoxide
    zsh
  ];

  system.stateVersion = "25.11";
}
