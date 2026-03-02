{ den, ... }:
{
  den.aspects.neonvoid = {
    includes = [
      # Shell tools
      den.aspects.zsh
      den.aspects.bat
      den.aspects.btop
      den.aspects.direnv
      den.aspects.fastfetch
      den.aspects.fzf
      den.aspects.ghostty
      den.aspects.git
      den.aspects.jq
      den.aspects.just
      den.aspects.kitty
      den.aspects.lazygit
      den.aspects.lsd
      den.aspects.nh
      den.aspects.payrespects
      den.aspects.tealdeer
      den.aspects.tv
      den.aspects.yazi
      den.aspects.zoxide

      # Desktop
      den.aspects."desktop-environment"
      den.aspects.fonts
      den.aspects.xdg
      den.aspects.stylix
      den.aspects.noctalia
      den.aspects.flatpak
      den.aspects.clipboard
      den.aspects.cursor
      den.aspects.firefox
      den.aspects.gtk
      den.aspects.hyprland
      den.aspects.hypridle
      den.aspects.hyprpolkitagent
      den.aspects.hyprshot
      den.aspects.thunar

      # Services (user-level)
      den.aspects."gnome-keyring"
      den.aspects.pipewire
      den.aspects.streamcontroller

      # Home
      den.aspects.common
      den.aspects.files
      den.aspects.packages

      # Media
      den.aspects.cava
      den.aspects.easyeffects
      den.aspects.mpv
      den.aspects."obs-studio"
      den.aspects.pics
      den.aspects.spicetify
      den.aspects.noisetorch

      # Gaming
      den.aspects.steam
      den.aspects.mangohud
      den.aspects.curseforge

      # Communication
      den.aspects.email
      den.aspects.vesktop

      # IDE
      den.aspects.nixcats
    ];

    nixos =
      { pkgs, ... }:
      {
        users.users.neonvoid = {
          description = "NeonVoid";
          shell = pkgs.zsh;
          extraGroups = [
            "networkmanager"
            "audio"
            "video"
            "input"
            "libvirtd"
          ];
        };
      };
  };
}
