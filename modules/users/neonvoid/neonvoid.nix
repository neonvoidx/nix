{ den, ... }:
{
  den.aspects.neonvoid = {
    includes = [
      # Shell tools
      den.aspects.bat
      den.aspects.btop
      den.aspects.direnv
      den.aspects.delta
      den.aspects.fastfetch
      den.aspects.fzf
      den.aspects.git
      den.aspects.ghostty
      den.aspects.jj
      den.aspects.jq
      den.aspects.just
      den.aspects.ghostty
      den.aspects.lazygit
      den.aspects.lsd
      den.aspects.mcp
      den.aspects.nh
      den.aspects.nix-index
      den.aspects.nvim
      den.aspects.opencode
      den.aspects.payrespects
      den.aspects.starship
      # den.aspects.pure
      den.aspects.tealdeer
      den.aspects.tmux
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

      # Communication
      den.aspects.discord
      den.aspects.email
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
