{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (pkgs.callPackage ../../modules/programs/scopebuddy.nix { })
    (pkgs.callPackage ../../modules/programs/hyprshutdown.nix { })
    asciinema
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
    gvfs
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
    # TODO fix after
    # oculante
    protontricks
    protonup-rs
    prusa-slicer
    hyprpwcenter
    seahorse
    # TODO uncomment after fix
    # sgdboop
    slurp
    steam
    streamcontroller
    tenacity
    thunderbird
    vulkan-tools
    wl-clip-persist
    wl-clipboard
    thunar
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-volman
    yarn
  ];
}
