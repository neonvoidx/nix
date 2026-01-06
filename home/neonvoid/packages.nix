{ pkgs, nixpkgs-sgdboop, ... }:
{
  home.packages = with pkgs; [
    (pkgs.callPackage ../../modules/programs/scopebuddy.nix { })
    (pkgs.callPackage ../../modules/programs/hyprshutdown.nix { })
    asciinema
    blueman
    cmatrix
    gamescope
    gimp
    github-copilot-cli
    grim
    gvfs
    hyprpicker
    hyprsysteminfo
    kdePackages.ark
    kdePackages.okular
    libsecret
    oculante
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
    vulkan-tools
    wl-clipboard
    thunar
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-volman
  ];
}
