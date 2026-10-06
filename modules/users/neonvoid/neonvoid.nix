{ den, ... }:
{
  den.aspects.neonvoid = {
    includes = [
      # Shell tools
      den.aspects.bat
      den.aspects.btop
      den.aspects.direnv
      den.aspects.devenv
      den.aspects.delta
      den.aspects.eza
      den.aspects.fastfetch
      den.aspects.fzf
      den.aspects.git
      den.aspects.kitty
      den.aspects.just
      den.aspects.lazygit
      den.aspects.mcp
      den.aspects.nh
      den.aspects.nix-index
      den.aspects.nvim
      den.aspects.opencode
      den.aspects.pay-respects
      den.aspects.starship
      den.aspects.tealdeer
      den.aspects.tmux
      den.aspects.yazi
      den.aspects.zoxide
      den.aspects.zsh

      # Desktop
      den.aspects.desktop-environment
      den.aspects.fonts
      den.aspects.xdg
      den.aspects.stylix
      den.aspects.noctalia
      den.aspects.flatpak
      den.aspects.clipboard
      den.aspects.cursor
      den.aspects.firefox
      den.aspects.gtk
      den.aspects.umbriel
      den.aspects.thunar
      den.aspects.xembsni

      # Services (user-level)
      den.aspects.gnome-keyring
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
      den.aspects.obs-studio
      # Wallpaper repository comes from user.wallpaperRepository
      den.aspects.pics
      # den.aspects.spicetify
      den.aspects.youtube-music

      # Communication
      den.aspects.discord
      den.aspects.email
    ];

    nixos = {
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
