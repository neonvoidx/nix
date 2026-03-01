{ self, lib, ... }:
{
  flake.modules = lib.mkMerge [
    (self.factory.user "neonvoid" true)
    {
      nixos.neonvoid =
        { ... }:
        {
          users.users.neonvoid = {
            description = "NeonVoid";
            extraGroups = [
              "networkmanager"
              "audio"
              "video"
              "input"
              "libvirtd"
            ];
          };
        };

      homeManager.neonvoid =
        { ... }:
        {
          imports = [
            self.modules.homeManager.common
            self.modules.homeManager.packages
            self.modules.homeManager.files

            # Shell
            self.modules.homeManager.bat
            self.modules.homeManager.btop
            self.modules.homeManager.clipboard
            self.modules.homeManager.direnv
            self.modules.homeManager.fastfetch
            self.modules.homeManager.fzf
            self.modules.homeManager.git
            self.modules.homeManager.jq
            self.modules.homeManager.just
            self.modules.homeManager.kitty
            self.modules.homeManager.ghostty
            self.modules.homeManager.lazygit
            self.modules.homeManager.lsd
            self.modules.homeManager.nh
            self.modules.homeManager.payrespects
            self.modules.homeManager.tealdeer
            self.modules.homeManager.yazi
            self.modules.homeManager.zoxide
            self.modules.homeManager.zsh

            # Desktop
            self.modules.homeManager.cursor
            self.modules.homeManager.firefox
            self.modules.homeManager.flatpak
            self.modules.homeManager.gtk
            self.modules.homeManager.hyprland
            self.modules.homeManager.hypridle
            self.modules.homeManager.hyprpolkitagent
            self.modules.homeManager.hyprshot
            self.modules.homeManager.noctalia
            self.modules.homeManager.stylix
            self.modules.homeManager.thunar

            # Security
            self.modules.homeManager.gnome-keyring

            # Audio
            self.modules.homeManager.cava
            self.modules.homeManager.easyeffects
            self.modules.homeManager.noisetorch

            # Media
            self.modules.homeManager.mpv
            self.modules.homeManager.obs-studio
            self.modules.homeManager.pics
            self.modules.homeManager.spicetify
            self.modules.homeManager.tv

            # Gaming
            self.modules.homeManager.curseforge
            self.modules.homeManager.mangohud
            self.modules.homeManager.steam

            # Apps
            self.modules.homeManager.email
            self.modules.homeManager.vesktop

            # IDE
            self.modules.homeManager.nixcats
          ];
        };
    }
  ];
}
