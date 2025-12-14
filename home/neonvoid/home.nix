{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
    ../configs/linux
  ];

  home.packages = with pkgs; [
    (pkgs.callPackage ../../modules/programs/scopebuddy.nix { })
    adw-gtk3
    asciinema
    blender
    blueman
    calibre
    cava
    cliphist
    cmatrix
    fractal
    gamescope
    gimp
    gnome-keyring
    grim
    hyprcursor
    hyprpicker
    hyprshot
    hyprsysteminfo
    kdePackages.ark
    kdePackages.okular
    libsecret
    mangohud
    mpv
    nodejs_24
    nwg-look
    obs-studio
    oculante
    protonmail-bridge
    protontricks
    protonup-rs
    prusa-slicer
    pwvucontrol
    seahorse
    sgdboop
    slurp
    steam
    streamcontroller
    tenacity
    thunderbird
    vesktop
    vulkan-tools
    wl-clip-persist
    wl-clipboard
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman
    yarn
  ];

  programs.git = {
    settings = {
      credential = {
        "https://github.com" = {
          helper = "!/usr/bin/gh auth git-credential";
        };
      };
      user = {
        name = "neonvoidx";
        email = "me@neonvoid.dev";
      };
    };
  };

  xresources.properties = {
    "Xcursor.size" = 24;
  };
  programs.bash = {
    enable = true;
  };
  gtk = {
    colorScheme = "dark";
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    cursorTheme = {
      name = "catppuccin-mocha-sapphire-cursors";
      package = pkgs.catppuccin-cursors.mochaSapphire;
    };
    font = {
      name = "Roboto Bold";
      size = 13;
    };
    gtk3 = {
      colorScheme = "dark";
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4 = {
      colorScheme = "dark";
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };

  # Dotfiles not managed via home manager yet
  # TODO
  home.file.".face".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/.face";
  home.file."scripts".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/scripts";
  home.file.".config/scopebuddy".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/scopebuddy";
}
