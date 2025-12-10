{ pkgs, ... }: {
  imports = [ ../common.nix ];

  home.packages = with pkgs; [
    (pkgs.callPackage ../../modules/scopebuddy.nix { })
    adw-gtk3
    asciinema
    blender
    blueman
    calibre
    cava
    cliphist
    easyeffects
    fractal
    gimp
    gnome-keyring
    grim
    hyprcursor
    hyprpicker
    hyprshot
    hyprsysteminfo
    kdePackages.ark
    kdePackages.okular
    mangohud
    mpv
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
    spicetify-cli
    spotify
    streamcontroller
    tenacity
    thunderbird
    vesktop
    wl-clip-persist
    wl-clipboard
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman
  ];
  programs.git = {
    settings = {
      credential = {
        "https://github.com" = { helper = "!/usr/bin/gh auth git-credential"; };
      };
      user = {
        name = "neonvoidx";
        email = "me@neonvoid.dev";
      };
    };
  };

  # Misc dotfiles
  home.file.".face".source = ../../assets/.face;
}
