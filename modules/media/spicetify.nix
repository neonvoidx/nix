{ den, inputs, ... }:
{
  den.aspects.spicetify.homeManager =
    { pkgs, ... }:
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      programs.spicetify = {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          beautifulLyrics
          catJamSynced
          copyLyrics
          fullAlbumDate
          fullAppDisplay
          groupSession
          history
          keyboardShortcut
          loopyLoop
          popupLyrics
          shuffle
        ];
        enabledCustomApps = with spicePkgs.apps; [
          marketplace
          newReleases
        ];
        theme = spicePkgs.themes.sleek;
        colorScheme = "Eldritch";
        wayland = true;
        windowManagerPatch = true;
      };
    };
}
