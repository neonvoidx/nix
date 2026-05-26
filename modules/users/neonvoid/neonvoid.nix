{ den, ... }:
{
  den.aspects.neonvoid = {
    includes = [
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
      den.aspects.mcp
      den.aspects.nh
      den.aspects.neovim
      den.aspects.opencode
      den.aspects.payrespects
      den.aspects.starship
      den.aspects.tealdeer
      den.aspects.yazi
      den.aspects.zoxide
      den.aspects.zsh

      # Desktop
      den.aspects.de
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
      den.aspects.satty
      den.aspects.thunar

      # Services (user-level)
      den.aspects.gnomekeyring
      den.aspects.pipewire
      den.aspects.streamcontroller
      den.aspects.usb

      # Home
      den.aspects.common
      den.aspects.files
      den.aspects.packages

      # Media
      den.aspects.cava
      den.aspects.easyeffects
      den.aspects.mpv
      den.aspects.obsstudio
      # My personal wallpapers
      # pulls from my repo, if you want to pull your own
      # wallpaper pics repo, change pics.nix url
      den.aspects.pics
      den.aspects.spicetify

      # Gaming
      den.aspects.steam
      den.aspects.mangohud

      # Communication
      # Setups thunderbird and protonmailbridge, unique to my user, edit email.nix to setup your accounts
      den.aspects.email
      den.aspects.vesktop
    ];

    nixos =
      { ... }:
      {
        users.users.neonvoid = {
          description = "neonvoid";
          extraGroups = [
            "networkmanager"
            "audio"
            "video"
            "input"
            "libvirtd"
            "dialout"
          ];
        };
      };
  };
}
