{ config, pkgs, inputs, ... }:

let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      hidePodcasts
      shuffle
      groupSession
      fullAppDisplay
    ];
    enabledCustomApps = with spicePkgs.apps; [ marketplace ];
  };
}
