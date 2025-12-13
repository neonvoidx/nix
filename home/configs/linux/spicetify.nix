{ config, pkgs, inputs, ... }:
let
  spicePkgs =
    inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      beautifulLyrics
      loopyLoop
      groupSession
      fullAppDisplay
      keyboardShortcut
      popupLyrics
      history
      copyLyrics
      catJamSynced
    ];
    enabledCustomApps = with spicePkgs.apps; [ marketplace ];
    theme = spicePkgs.themes.sleek;
    colorScheme = "Eldritch";
    wayland = true;
  };
}
