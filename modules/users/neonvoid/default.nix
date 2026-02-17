{ self, ... }:
{
  # User aspects define BOTH system AND homeManager modules

  # System-level user account configuration
  flake.modules.nixos.neonvoid =
    { pkgs, ... }:
    {
      users.users.neonvoid = {
        isNormalUser = true;
        description = "NeonVoid";
        extraGroups = [
          "networkmanager"
          "wheel"
          "audio"
          "video"
          "input"
          "libvirtd"
        ];
        shell = pkgs.zsh;
      };
      programs.zsh.enable = true;
    };

  # Home-Manager configuration (collector for all HM aspects)
  flake.modules.homeManager.neonvoid =
    { ... }:
    {
      imports = [
        # Base configuration
        self.modules.homeManager.common
        self.modules.homeManager.packages
        self.modules.homeManager.git
        self.modules.homeManager.files

        # All program/tool configs
        self.modules.homeManager.bat
        self.modules.homeManager.btop
        self.modules.homeManager.cava
        self.modules.homeManager.clipboard
        self.modules.homeManager.curseforge
        self.modules.homeManager.cursor
        self.modules.homeManager.direnv
        self.modules.homeManager.noctalia
        self.modules.homeManager.easyeffects
        self.modules.homeManager.email
        self.modules.homeManager.fastfetch
        self.modules.homeManager.firefox
        self.modules.homeManager.flatpak
        self.modules.homeManager.fzf
        self.modules.homeManager.ghostty
        self.modules.homeManager.gnome-keyring
        self.modules.homeManager.gtk
        self.modules.homeManager.hypridle
        self.modules.homeManager.hyprland
        self.modules.homeManager.hyprpolkitagent
        self.modules.homeManager.hyprshot
        self.modules.homeManager.jq
        self.modules.homeManager.just
        self.modules.homeManager.kitty
        self.modules.homeManager.lazygit
        self.modules.homeManager.lsd
        self.modules.homeManager.mangohud
        self.modules.homeManager.mpv
        self.modules.homeManager.nh
        self.modules.homeManager.nixcats
        self.modules.homeManager.noisetorch
        self.modules.homeManager.obs-studio
        self.modules.homeManager.payrespects
        self.modules.homeManager.pics
        self.modules.homeManager.spicetify
        self.modules.homeManager.stylix
        self.modules.homeManager.tealdeer
        self.modules.homeManager.thunar
        self.modules.homeManager.tv
        self.modules.homeManager.vesktop
        self.modules.homeManager.wowup-cf
        self.modules.homeManager.yazi
        self.modules.homeManager.zoxide
        self.modules.homeManager.zsh
      ];
    };
}
