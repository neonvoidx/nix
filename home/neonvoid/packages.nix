{ pkgs, nixpkgs-sgdboop, ... }:
{
  home.packages = with pkgs; [
    (pkgs.callPackage ../../modules/programs/hyprshutdown.nix { })
    asciinema
    blueman
    cmatrix
    gamescope
    gimp
    grim
    gvfs
    # TODO from here down check for home manager configs
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
    nixpkgs-sgdboop.legacyPackages.${pkgs.stdenv.hostPlatform.system}.sgdboop
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
