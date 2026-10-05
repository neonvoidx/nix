{ den, inputs, ... }:
{
  den.aspects.youtube-music.homeManager =
    { pkgs, ... }:
    let
      cthulhuTheme = pkgs.fetchurl {
        name = "eldritch-cthulhu.css";
        url = "https://raw.githubusercontent.com/eldritch-theme/youtube-music/a1dc1799b1b93ed765f3269d9ad5f05de63800a7/themes/eldritch-cthulhu.css";
        hash = "sha256-+9K2h6ctyBq/jk81TnLQa2ba8Sp5f8alcSsleldEK5o=";
      };
    in
    {
      imports = [ inputs.pear-desktop.homeManagerModules.default ];

      programs.pear-desktop = {
        enable = true;
        options = {
          appVisible = true;
          customWindowTitle = "Pear";
          hideMenu = true;
          language = "en";
          likeButtons = "force";
          restartOnConfigChanges = true;
          startingPage = "Home";
          themes = [
            "${cthulhuTheme}"
          ];
          # Setting tray = true makes the tray work, but hides the window at startup.
          tray = true;
        };
        plugins = {
          album-actions.enable = true;
          album-color-theme = {
            enable = true;
            enableSeekbar = true;
          };
          ambient-mode = {
            enable = true;
            blur = 100;
          };
          blur-nav-bar.enable = true;
          disable-autoplay = {
            enable = true;
            applyOnce = true;
          };
          discord = {
            enable = true;
            hideGitHubButton = true;
          };
          downloader = {
            enable = true;
          };
          in-app-menu.enable = true;
          performance-improvement.enable = true;
          playback-speed.enable = true;
          precise-volume.enable = true;
          quality-changer.enable = true;
          shortcuts.enable = true;
          synced-lyrics = {
            enable = true;
          };
          transparent-player = {
            enable = true;
            opacity = 0.5;
          };
          tuna-obs.enable = true;
          video-toggle = {
            enable = true;
          };
        };
      };
    };
}
