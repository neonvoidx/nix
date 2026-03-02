{ den, inputs, ... }:
{
  den.aspects.neonvoid = {
    # den batteries: set up user account, admin privileges, and zsh shell
    includes = [
      den._.define-user
      den._.primary-user
      (den._.user-shell "zsh")

      # Shell tools
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
      den.aspects.zsh

      # Home base
      den.aspects.common
      den.aspects.files
      den.aspects.packages

      # Desktop / Hyprland
      den.aspects.hyprland
      den.aspects.hypridle
      den.aspects.hyprpolkitagent
      den.aspects.hyprshot
      den.aspects.clipboard
      den.aspects.cursor
      den.aspects.firefox
      den.aspects.gtk
      den.aspects.thunar
      den.aspects.stylix
      den.aspects.noctalia

      # Media & Gaming
      den.aspects.cava
      den.aspects.easyeffects
      den.aspects.mpv
      den.aspects.obs-studio
      den.aspects.spicetify
      den.aspects.noisetorch
      den.aspects.pics
      den.aspects.steam
      den.aspects.mangohud
      den.aspects.curseforge

      # Communication
      den.aspects.email
      den.aspects.vesktop
      den.aspects.gnome-keyring

      # IDE
      den.aspects.nixcats
    ];

    nixos.users.users.neonvoid = {
      description = "NeonVoid";
      extraGroups = [
        "networkmanager"
        "audio"
        "video"
        "input"
        "libvirtd"
      ];
    };

    # Home-Manager configuration: import external HM modules
    homeManager = { ... }: {
      imports = [
        # External HM modules (previously in home-manager.sharedModules)
        inputs.spicetify-nix.homeManagerModules.default
        inputs.nix-index-database.homeModules.default
        inputs.noctalia.homeModules.default
      ];
    };
  };
}
